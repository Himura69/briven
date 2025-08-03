import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../admin/models/assignment_form_options_model.dart';

class AdminAssignmentWizardController extends GetxController {
  final api = Get.find<ApiService>();

  // Mode edit
  Map<String, dynamic>? existingData;
  int? assignmentId;
  bool get isEditMode => assignmentId != null;
  bool _isPrefilled = false;

  // Stepper state
  var currentStep = 0.obs;

  // Form fields
  Rxn<FormOption> selectedDevice = Rxn<FormOption>();
  Rxn<FormOption> selectedUser = Rxn<FormOption>();
  Rxn<FormOption> selectedBranch = Rxn<FormOption>();
  Rxn<DateTime> assignedDate = Rxn<DateTime>();
  RxString notes = ''.obs;

  // Surat Penugasan
  RxString letterNumber = ''.obs;
  Rxn<DateTime> letterDate = Rxn<DateTime>();
  Rx<File?> letterFile = Rx<File?>(null);

  // Options
  var deviceOptions = <FormOption>[].obs;
  var userOptions = <FormOption>[].obs;
  var branchOptions = <FormOption>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Map && args.containsKey('assignmentId')) {
      assignmentId = args['assignmentId'];
      fetchAssignmentDetail();
    } else {
      fetchFormOptions();
    }
  }

  Future<void> fetchAssignmentDetail() async {
    if (assignmentId == null) return;

    try {
      isLoading.value = true;
      existingData = await api.getDeviceAssignmentDetail(assignmentId!);
      if (existingData?['deviceId'] == null) {
        _showErrorSnackBar('Data perangkat kosong, tidak bisa prefill');
        return;
      }
      await fetchFormOptions();
      prefillForm();
    } catch (e) {
      _showErrorSnackBar('Gagal mengambil detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFormOptions() async {
    try {
      isLoading.value = true;
      final data = await api.getDeviceAssignmentFormOptions();

      deviceOptions.value =
          (data['devices'] as List).map((e) => FormOption.fromJson(e)).toList();
      userOptions.value =
          (data['users'] as List).map((e) => FormOption.fromJson(e)).toList();
      branchOptions.value = (data['branches'] as List)
          .map((e) => FormOption.fromJson(e))
          .toList();

      if (isEditMode && deviceOptions.isNotEmpty) {
        prefillForm();
      }
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void prefillForm() {
    if (_isPrefilled || existingData == null) return;
    _isPrefilled = true;

    final deviceId = int.tryParse('${existingData?['deviceId']}');
    final assignedName =
        (existingData?['assignedTo'] ?? '').toString().toLowerCase();
    final unitName = (existingData?['unitName'] ?? '').toString().toLowerCase();

    selectedDevice.value =
        deviceOptions.firstWhereOrNull((d) => d.id == deviceId);

    selectedUser.value = userOptions.firstWhereOrNull(
      (u) => u.label.toLowerCase().contains(assignedName),
    );

    selectedBranch.value = branchOptions.firstWhereOrNull(
      (b) => b.label.toLowerCase().contains(unitName),
    );

    assignedDate.value = DateTime.tryParse(existingData?['assignedDate'] ?? '');
    notes.value = existingData?['notes'] ?? '';

    final letters = existingData?['assignmentLetters'] as List<dynamic>?;
    final surat = letters?.firstWhereOrNull(
      (e) => e['assignmentType'] == 'assignment',
    );

    if (surat != null) {
      letterNumber.value = surat['letterNumber'] ?? '';
      letterDate.value = DateTime.tryParse(surat['letterDate'] ?? '');
    }
  }

  void nextStep() {
    if (currentStep.value < 3) currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

  Future<void> handleSubmit() async {
    final fields = {
      'device_id': selectedDevice.value?.id,
      'user_id': selectedUser.value?.id,
      'assigned_date': assignedDate.value != null
          ? DateFormat('yyyy-MM-dd').format(assignedDate.value!)
          : null,
      'status': 'Digunakan',
      'notes': notes.value,
      'letter_number': letterNumber.value,
      'letter_date': letterDate.value != null
          ? DateFormat('yyyy-MM-dd').format(letterDate.value!)
          : null,
    };

    try {
      isLoading.value = true;
      Map<String, dynamic> response;

      if (isEditMode) {
        if (assignmentId == null) {
          _showErrorSnackBar('ID penugasan tidak tersedia.');
          return;
        }
        response = await api.updateDeviceAssignment(
          assignmentId: assignmentId!,
          fields: fields,
          pdfFile: letterFile.value,
        );
        _showSuccessSnackBar('Penugasan berhasil diperbarui.');
      } else {
        response = await api.createDeviceAssignment(
          fields: fields,
          pdfFile: letterFile.value,
        );
        _showSuccessSnackBar('Penugasan berhasil dibuat.');
      }
    } catch (e) {
      _showErrorSnackBar('Gagal menyimpan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAssignment() async {
    if (assignmentId == null) {
      _showErrorSnackBar('ID assignment tidak ditemukan.');
      return;
    }

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus assignment ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      isLoading.value = true;
      await api.deleteDeviceAssignment(assignmentId!);
      _showSuccessSnackBar('Assignment berhasil dihapus.');
      Get.back(); // Navigasi kembali setelah delete berhasil
    } catch (e) {
      _showErrorSnackBar('Gagal menghapus: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    selectedDevice.value = null;
    selectedUser.value = null;
    selectedBranch.value = null;
    assignedDate.value = null;
    notes.value = '';
    letterNumber.value = '';
    letterDate.value = null;
    letterFile.value = null;
    currentStep.value = 0;
    _isPrefilled = false;
  }

  void _showSuccessSnackBar(String message) {
    Get.snackbar(
      'Sukses',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: const EdgeInsets.all(12),
    );
  }

  void _showErrorSnackBar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      margin: const EdgeInsets.all(12),
    );
  }
}
