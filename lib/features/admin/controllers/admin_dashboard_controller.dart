import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../models/kpi_model.dart';
import '../models/chart_data_model.dart';

class AdminDashboardController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  var kpiData = Rxn<KpiModel>();
  var chartData = Rxn<ChartDataModel>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData({int? branchId}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Ambil data KPI dari ApiService
      final kpiResponse = await apiService.getAdminKPIs(branchId: branchId);
      kpiData.value = KpiModel.fromJson(kpiResponse);

      // Ambil data Chart dari ApiService
      final chartResponse = await apiService.getAdminCharts(branchId: branchId);
      chartData.value = ChartDataModel.fromJson(chartResponse);
    } catch (e) {
      errorMessage.value = 'Gagal memuat data dashboard: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
