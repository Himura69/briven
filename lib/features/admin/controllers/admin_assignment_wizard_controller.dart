import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
      print('📦 [onInit] assignmentId DITERIMA: $assignmentId');
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
      print('📡 [fetchAssignmentDetail] Data: $existingData');

      if (existingData?['deviceId'] == null) {
        Get.snackbar('Peringatan', 'Data perangkat kosong, tidak bisa prefill');
        return;
      }

      await fetchFormOptions();
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFormOptions() async {
    try {
      isLoading.value = true;
      final data = await api.getDeviceAssignmentFormOptions();
      print('🟢 [fetchFormOptions] Response: ${data.keys}');

      deviceOptions.value =
          (data['devices'] as List).map((e) => FormOption.fromJson(e)).toList();
      userOptions.value =
          (data['users'] as List).map((e) => FormOption.fromJson(e)).toList();
      branchOptions.value = (data['branches'] as List)
          .map((e) => FormOption.fromJson(e))
          .toList();

      print('✅ Device IDs: ${deviceOptions.map((d) => d.id).toList()}');
      print('✅ User labels: ${userOptions.map((u) => u.label).toList()}');
      print('✅ Branch labels: ${branchOptions.map((b) => b.label).toList()}');

      if (isEditMode && deviceOptions.isNotEmpty) {
        prefillForm();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void prefillForm() {
    if (_isPrefilled || existingData == null) return;
    _isPrefilled = true;

    print('🔧 [prefill] Mulai prefill...');
    final deviceId = int.tryParse('${existingData?['deviceId']}');
    final assignedName =
        (existingData?['assignedTo'] ?? '').toString().toLowerCase();
    final unitName = (existingData?['unitName'] ?? '').toString().toLowerCase();

    print('📥 deviceId: $deviceId');
    print('📥 assignedTo: $assignedName');
    print('📥 unitName: $unitName');

    // Prefill device
    selectedDevice.value =
        deviceOptions.firstWhereOrNull((d) => d.id == deviceId);
    if (selectedDevice.value == null) {
      print('⚠️ Device dengan ID $deviceId tidak ditemukan di deviceOptions');
    }
    print('🎯 Device terpilih: ${selectedDevice.value}');

    // Prefill user
    selectedUser.value = userOptions.firstWhereOrNull(
      (u) => u.label.toLowerCase().contains(assignedName),
    );
    if (selectedUser.value == null) {
      print('⚠️ Tidak ditemukan user dengan nama $assignedName');
    }
    print('🎯 User terpilih: ${selectedUser.value}');

    // Prefill branch
    selectedBranch.value = branchOptions.firstWhereOrNull(
      (b) => b.label.toLowerCase().contains(unitName),
    );
    if (selectedBranch.value == null) {
      print('⚠️ Tidak ditemukan branch dengan nama $unitName');
    }
    print('🎯 Branch terpilih: ${selectedBranch.value}');

    // Prefill tanggal & notes
    assignedDate.value = DateTime.tryParse(existingData?['assignedDate'] ?? '');
    notes.value = existingData?['notes'] ?? '';

    print('📆 assignedDate: ${assignedDate.value}');
    print('📝 notes: ${notes.value}');

    // Prefill surat penugasan
    final letters = existingData?['assignmentLetters'] as List<dynamic>?;
    final surat = letters?.firstWhereOrNull(
      (e) => e['assignmentType'] == 'assignment',
    );

    if (surat != null) {
      letterNumber.value = surat['letterNumber'] ?? '';
      letterDate.value = DateTime.tryParse(surat['letterDate'] ?? '');
    }

    print('📄 letterNumber: ${letterNumber.value}');
    print('📄 letterDate: ${letterDate.value}');
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

    print('🚀 [handleSubmit] Mode: ${isEditMode ? "EDIT" : "CREATE"}');
    print('📤 [handleSubmit] Field Values:');
    fields.forEach((key, value) {
      print('  - $key: $value');
    });
    print('📎 [handleSubmit] File: ${letterFile.value?.path}');

    try {
      isLoading.value = true;
      Map<String, dynamic> response;

      if (isEditMode) {
        response = await api.updateDeviceAssignment(
          assignmentId: assignmentId!,
          fields: fields,
          pdfFile: letterFile.value,
        );
        Get.snackbar('Success', 'Assignment updated.');
      } else {
        response = await api.createDeviceAssignment(
          fields: fields,
          pdfFile: letterFile.value,
        );
        Get.snackbar('Success', 'Assignment created.');
      }

      Get.back(result: response);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Get.theme.colorScheme.error);
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
}
