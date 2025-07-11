import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_service.dart';
import '../models/device_model.dart';

class DevicesListController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final GetStorage storage = GetStorage();
  final devices = <DeviceModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    print('DevicesListController diinisialisasi');
    print('Token tersimpan: ${storage.read('token')}');
    if (storage.read('token') == null) {
      errorMessage.value = 'Sesi berakhir. Silakan login kembali.';
      Get.offAllNamed('/login');
    } else {
      fetchDevices();
    }
    super.onInit();
  }

  Future<void> fetchDevices() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final token = storage.read('token');
      if (token == null) {
        throw Exception('Token autentikasi tidak ditemukan');
      }
      print('Mengambil perangkat dengan token: $token');
      final response = await apiService.getDevices();
      print('Respons perangkat: $response');
      if (response is List<dynamic>) {
        devices.value = response.map((item) {
          if (item is Map<String, dynamic>) {
            print('Memetakan item: $item'); // Log setiap item
            return DeviceModel.fromJson(item);
          } else {
            throw Exception('Format item perangkat tidak valid: $item');
          }
        }).toList();
        print('Perangkat yang dipetakan: ${devices.map((d) => d.toJson())}');
      } else {
        throw Exception(
            'Diharapkan daftar perangkat, tetapi mendapat: $response');
      }
    } catch (e) {
      print('Error pengambilan perangkat: $e');
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
        message = 'Gagal memuat perangkat: $e';
      }
      errorMessage.value = message;
      Get.snackbar('Error', message);
    } finally {
      isLoading.value = false;
    }
  }
}
