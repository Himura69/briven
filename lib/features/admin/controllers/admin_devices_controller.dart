import 'package:get/get.dart';
import '../../../../services/api_service.dart';
import '../models/admin_device_model.dart';

class AdminDevicesController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  var devices = <AdminDeviceModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var total = 0.obs;

  var searchQuery = ''.obs;
  var conditionFilter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDevices();
  }

  Future<void> fetchDevices({int page = 1}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.getDevicesAdmin(
        search: searchQuery.value,
        condition: conditionFilter.value,
        page: page,
        perPage: 10,
      );

      final data = response['data'] as List<dynamic>;
      devices.value = data.map((e) => AdminDeviceModel.fromJson(e)).toList();

      final meta = response['meta'] as Map<String, dynamic>;
      currentPage.value = meta['currentPage'] ?? 1;
      lastPage.value = meta['lastPage'] ?? 1;
      total.value = meta['total'] ?? devices.length;
    } catch (e) {
      errorMessage.value = 'Gagal memuat perangkat: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    searchQuery.value = query;
    fetchDevices(page: 1);
  }

  void filterCondition(String condition) {
    conditionFilter.value = condition;
    fetchDevices(page: 1);
  }

  void nextPage() {
    if (currentPage.value < lastPage.value) {
      fetchDevices(page: currentPage.value + 1);
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      fetchDevices(page: currentPage.value - 1);
    }
  }
}
