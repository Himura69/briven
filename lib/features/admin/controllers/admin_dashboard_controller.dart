import 'package:get/get.dart';
import '../../../services/api_service.dart';

class AdminDashboardController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  var isLoading = false.obs;
  var kpiData = {}.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchKpis();
    super.onInit();
  }

  Future<void> fetchKpis({int? branchId}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await apiService.getAdminKpis(branchId: branchId);
      kpiData.value = response;
    } catch (e) {
      errorMessage.value = 'Gagal memuat KPI: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}