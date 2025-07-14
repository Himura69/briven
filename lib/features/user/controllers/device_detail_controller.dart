import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_service.dart';
import '../models/device_detail_model.dart';

class DeviceDetailController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final GetStorage storage = GetStorage();
  final device = Rxn<DeviceDetailModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    final deviceId = Get.arguments['deviceId'] as int?;
    if (deviceId == null) {
      errorMessage.value = 'ID perangkat tidak valid';
      Get.snackbar('Error', 'ID perangkat tidak valid');
      return;
    }
    print('DeviceDetailController diinisialisasi dengan deviceId: $deviceId');
    print('Token tersimpan: ${storage.read('token')}');
    if (storage.read('token') == null) {
      errorMessage.value = 'Sesi berakhir. Silakan login kembali.';
      Get.offAllNamed('/login');
    } else {
      fetchDeviceDetail(deviceId);
    }
    super.onInit();
  }

  Future<void> fetchDeviceDetail(int deviceId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final token = storage.read('token');
      if (token == null) {
        throw Exception('Token autentikasi tidak ditemukan');
      }
      print('Mengambil detail perangkat dengan token: $token');
      final response = await apiService.getDeviceDetail(deviceId);
      print('Respons detail perangkat mentah: $response');
      device.value = DeviceDetailModel.fromJson(response);
      print('Perangkat yang dipetakan: ${device.value?.toJson()}');
    } catch (e) {
      print('Error pengambilan detail perangkat: $e');
      String message = e.toString();
      if (message.contains('401') || message.contains('Unauthenticated')) {
        message = 'Sesi berakhir. Silakan login kembali.';
        await storage.remove('token');
        await storage.remove('user');
        Get.offAllNamed('/login');
      } else if (message.contains('429')) {
        message = 'Terlalu banyak permintaan. Coba lagi nanti.';
      } else if (message.contains('type cast')) {
        message = 'Format data dari server tidak valid. Hubungi dukungan.';
      } else {
        message = 'Gagal memuat detail perangkat: $e';
      }
      errorMessage.value = message;
      Get.snackbar('Error', message);
    } finally {
      isLoading.value = false;
    }
  }
}