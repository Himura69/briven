import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../models/admin_device_model.dart';

class AdminDevicesController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  // State utama
  var devices = <AdminDeviceModel>[].obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var total = 0.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Untuk form (dropdown & validation)
  var formOptions = {}.obs;
  var validationRules = {}.obs;
  var searchQuery = ''.obs;
  var selectedCondition = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchDevices();
  }

  // ===========================
  // FETCH LIST PERANGKAT
  // ===========================
  Future<void> fetchDevices({int page = 1}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.getAdminDevices(
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        condition:
            selectedCondition.value.isNotEmpty ? selectedCondition.value : null,
        page: page,
        perPage: 20,
      );

      // Validasi data
      if (response['data'] is! List) {
        throw Exception("Format data tidak valid dari server: data bukan List");
      }

      final data = response['data'] as List<dynamic>;
      devices.value = data.map((e) => AdminDeviceModel.fromJson(e)).toList();

      final meta = response['meta'];
      if (meta is Map<String, dynamic>) {
        currentPage.value = meta['currentPage'] ?? 1;
        lastPage.value = meta['lastPage'] ?? 1;
        total.value = meta['total'] ?? devices.length;
      } else {
        // Jika meta tidak tersedia atau bukan map, isi default
        currentPage.value = 1;
        lastPage.value = 1;
        total.value = devices.length;
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat perangkat: $e';
      devices.clear();
      total.value = 0;
      currentPage.value = 1;
      lastPage.value = 1;
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================
  // FETCH DETAIL PERANGKAT
  // ===========================
  Future<AdminDeviceModel?> fetchDeviceDetail(int deviceId) async {
    try {
      final data = await apiService.getAdminDeviceDetail(deviceId);
      return AdminDeviceModel.fromJson(data);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail perangkat: $e');
      return null;
    }
  }

  // ===========================
  // CRUD PERANGKAT
  // ===========================
  Future<bool> createDevice(Map<String, dynamic> payload) async {
    try {
      await apiService.createAdminDevice(payload);
      await fetchDevices(); // Refresh list
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDevice(int id, Map<String, dynamic> payload) async {
    try {
      await apiService.updateAdminDevice(id, payload);
      await fetchDevices(); // Refresh list
      // Get.snackbar('Sukses', 'Perangkat berhasil diperbarui');
      return true;
    } catch (e) {
      // Get.snackbar('Error', 'Gagal memperbarui perangkat: $e');
      return false;
    }
  }

  Future<bool> deleteDevice(int id) async {
    try {
      await apiService.deleteAdminDevice(id);
      await fetchDevices(); // Refresh list
      // Get.snackbar('Sukses', 'Perangkat berhasil dihapus');
      return true;
    } catch (e) {
      // Get.snackbar('Error', 'Gagal menghapus perangkat: $e');
      return false;
    }
  }

  // ===========================
  // FORM OPTIONS & VALIDATION
  // ===========================
  Future<void> loadFormOptions({String? field}) async {
    try {
      final options = await apiService.getDeviceFormOptions(field: field);
      formOptions.assignAll(options);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat pilihan form: $e');
    }
  }

  Future<void> loadValidationRules() async {
    try {
      final rules = await apiService.getDeviceValidationRules();
      validationRules.assignAll(rules);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat aturan validasi: $e');
    }
  }
}
