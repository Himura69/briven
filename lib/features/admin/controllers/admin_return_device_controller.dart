import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_service.dart';

class AdminReturnDeviceController extends GetxController {
  final api = Get.find<ApiService>();
  final storage = GetStorage();

  int? assignmentId;
  final RxString notes = ''.obs;
  final RxString letterNumber = ''.obs;
  final Rxn<DateTime> letterDate = Rxn<DateTime>();
  final Rx<File?> letterFile = Rx<File?>(null);

  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args.containsKey('assignmentId')) {
      assignmentId = args['assignmentId'];
    }
  }

  Future<void> submitReturn() async {
    if (assignmentId == null) {
      _showError('ID Penugasan tidak ditemukan.');
      return;
    }

    if (letterNumber.value.trim().isEmpty) {
      _showError('Nomor surat harus diisi.');
      return;
    }

    if (letterDate.value == null) {
      _showError('Tanggal surat harus diisi.');
      return;
    }

    if (letterFile.value == null) {
      _showError('File surat pengembalian belum dipilih.');
      return;
    }

    final user = storage.read('user');
    final updatedBy = user?['id'];
    if (updatedBy == null) {
      _showError('ID user tidak ditemukan di penyimpanan lokal.');
      return;
    }

    final fields = {
      'notes': notes.value,
      'letter_number': letterNumber.value,
      'letter_date': DateFormat('yyyy-MM-dd').format(letterDate.value!),
      'updated_by': updatedBy,
    };

    try {
      isSubmitting.value = true;

      final result = await api.returnDeviceAssignment(
        assignmentId: assignmentId!,
        fields: fields,
        letterFile: letterFile.value!,
      );

      _showSuccess('Pengembalian berhasil dikirim.');
      Get.back(result: result);
    } catch (e) {
      _showError('Gagal mengembalikan device: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Sukses',
      message,
      snackPosition: SnackPosition.TOP,
    );
  }
}
