import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../models/scanned_qr_result.dart'; // Sesuaikan path model

class QrScannerController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var scanResult = Rxn<ScannedQrResult>();

  Future<void> fetchScanResult(String qrCode) async {
    isLoading.value = true;
    errorMessage.value = '';
    scanResult.value = null;

    try {
      final response = await apiService.scanQrCode(qrCode); // panggil method dari ApiService

      if (response.statusCode == 200) {
        scanResult.value = ScannedQrResult.fromJson(response.body['data']);
      } else {
        errorMessage.value = response.body['message'] ?? 'Gagal memuat data.';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat mengambil data.';
    } finally {
      isLoading.value = false;
    }
  }
}
