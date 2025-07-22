import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../models/admin_device_model.dart';

class AdminDevicesController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  var devices = <AdminDeviceModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Pagination
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var total = 0.obs;

  // Filters
  var searchQuery = ''.obs;
  var selectedCondition = ''.obs; // Baik, Rusak, Perlu Pengecekan

  /// Ambil daftar perangkat dengan pagination & filter
  Future<void> fetchDevices({int page = 1, int perPage = 20}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await apiService.getDevicesAdmin(
        search: searchQuery.value,
        condition: selectedCondition.value,
        page: page,
        perPage: perPage,
      );

      final data = result['data'] as List<dynamic>;
      devices.value = data.map((e) => AdminDeviceModel.fromJson(e)).toList();

      final meta = result['meta'] ?? {};
      currentPage.value = meta['currentPage'] ?? 1;
      lastPage.value = meta['lastPage'] ?? 1;
      total.value = meta['total'] ?? devices.length;
    } catch (e) {
      errorMessage.value = 'Gagal memuat perangkat: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Ambil detail perangkat untuk view/edit
  Future<AdminDeviceModel?> fetchDeviceDetail(int id) async {
    try {
      final data = await apiService.getDeviceDetailAdmin(id);
      return AdminDeviceModel.fromJson(data);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil detail perangkat: $e');
      return null;
    }
  }

  /// Tambah perangkat baru
  Future<void> createDevice(Map<String, dynamic> formData) async {
    try {
      isLoading.value = true;
      await apiService.createDeviceAdmin(
        brand: formData['brand'],
        brandName: formData['brandName'],
        serialNumber: formData['serialNumber'],
        assetCode: formData['assetCode'],
        briboxId: formData['briboxId'],
        condition: formData['condition'],
        spec1: formData['spec1'],
        spec2: formData['spec2'],
        spec3: formData['spec3'],
        spec4: formData['spec4'],
        spec5: formData['spec5'],
        devDate: formData['devDate'],
      );
      await fetchDevices();
      Get.snackbar('Sukses', 'Perangkat berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah perangkat: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update perangkat
  Future<void> updateDevice(int id, Map<String, dynamic> formData) async {
    try {
      isLoading.value = true;
      await apiService.updateDeviceAdmin(
        deviceId: id,
        brand: formData['brand'],
        brandName: formData['brandName'],
        serialNumber: formData['serialNumber'],
        assetCode: formData['assetCode'],
        briboxId: formData['briboxId'],
        condition: formData['condition'],
        spec1: formData['spec1'],
        spec2: formData['spec2'],
        spec3: formData['spec3'],
        spec4: formData['spec4'],
        spec5: formData['spec5'],
        devDate: formData['devDate'],
      );
      await fetchDevices();
      Get.snackbar('Sukses', 'Perangkat berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui perangkat: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Hapus perangkat
  Future<void> deleteDevice(int id) async {
    try {
      isLoading.value = true;
      await apiService.deleteDeviceAdmin(id);
      await fetchDevices();
      Get.snackbar('Sukses', 'Perangkat berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus perangkat: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
