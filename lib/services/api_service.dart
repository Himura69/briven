import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiService extends GetConnect {
  final String baseUrl = 'http://192.168.2.203:8000/api/v1';
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
      request.headers['X-Device-Info'] = 'Flutter App, v1.0.0';
      final token = storage.read('token');
      print('URL Permintaan: ${request.url}');
      print('Header Permintaan: ${request.headers}');
      print('Token digunakan: $token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      } else {
        print('Token tidak ditemukan di penyimpanan');
      }
      return request;
    });
    httpClient.addResponseModifier((request, response) {
      print('Status Respons: ${response.statusCode}');
      print('Body Respons: ${response.bodyString}');
      return response;
    });
    super.onInit();
  }

  Future<Map<String, dynamic>> login({
    required String pn,
    required String password,
    required String deviceName,
  }) async {
    final response = await post('/auth/login', {
      'pn': pn,
      'password': password,
      'device_name': deviceName,
    });

    print('Respons login mentah: ${response.bodyString}');
    if (response.status.hasError) {
      final errorMessage =
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'Login gagal: ${response.statusCode}';
      throw Exception(errorMessage);
    }

    if (response.body == null || response.body['data'] == null) {
      throw Exception('Format respons dari server tidak valid');
    }

    return response.body['data'];
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = storage.read('token');
    if (token == null) {
      throw Exception('Token autentikasi tidak ditemukan');
    }

    final response = await get('/user/profile');
    if (response.status.hasError) {
      final errorMessage =
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'Gagal mengambil profil: ${response.statusCode}';
      throw Exception(errorMessage);
    }

    if (response.body == null || response.body['data'] == null) {
      throw Exception('Format respons profil tidak valid');
    }

    return response.body['data'];
  }

  Future<void> logout() async {
    final token = storage.read('token');
    if (token == null) {
      print('Tidak ada token untuk logout');
      return;
    }

    final response = await post('/auth/logout', {});
    print('Respons logout: ${response.bodyString}');
    if (response.status.hasError) {
      final errorMessage =
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'Logout gagal: ${response.statusCode}';
      throw Exception(errorMessage);
    }

    await storage.remove('token');
    await storage.remove('user');
    print('Token dan data user dihapus dari penyimpanan');
  }

  Future<Map<String, dynamic>> getHomeSummary() async {
    final token = storage.read('token');
    if (token == null) {
      throw Exception('Token autentikasi tidak ditemukan');
    }

    final response = await get('/user/home/summary');
    if (response.status.hasError) {
      final errorMessage =
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'Gagal mengambil ringkasan: ${response.statusCode}';
      throw Exception(errorMessage);
    }

    if (response.body == null || response.body['data'] == null) {
      throw Exception('Format respons ringkasan tidak valid');
    }

    return response.body['data'];
  }

  Future<List<dynamic>> getDevices() async {
    final token = storage.read('token');
    if (token == null) {
      throw Exception('Token autentikasi tidak ditemukan');
    }

    final response = await get('/user/devices');
    if (response.status.hasError) {
      final errorMessage =
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'Gagal mengambil perangkat: ${response.statusCode}';
      throw Exception(errorMessage);
    }

    if (response.body == null || response.body['data'] == null) {
      throw Exception('Format respons perangkat tidak valid');
    }

    if (response.body['data'] is! List<dynamic>) {
      throw Exception(
          'Data respons perangkat bukan daftar: ${response.body['data']}');
    }

    return response.body['data'];
  }

  Future<Map<String, dynamic>> getDeviceDetail(int deviceId) async {
    final token = storage.read('token');
    if (token == null) {
      throw Exception('Token autentikasi tidak ditemukan');
    }

    final response = await get('/user/devices/$deviceId');
    print('Respons detail perangkat: ${response.bodyString}');
    if (response.status.hasError) {
      final errorMessage =
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'Gagal mengambil detail perangkat: ${response.statusCode}';
      throw Exception(errorMessage);
    }

    if (response.body == null || response.body['data'] == null) {
      throw Exception('Format respons detail perangkat tidak valid');
    }

    return response.body['data'];
  }

  Future<Map<String, dynamic>> getLoanHistory(
      {int page = 1, int perPage = 10}) async {
    final token = storage.read('token');
    if (token == null) {
      throw Exception('Token autentikasi tidak ditemukan');
    }

    final response = await get('/user/history?page=$page&perPage=$perPage');
    print('Respons riwayat peminjaman: ${response.bodyString}');
    if (response.status.hasError) {
      final errorMessage =
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'Gagal mengambil riwayat peminjaman: ${response.statusCode}';
      throw Exception(errorMessage);
    }

    if (response.body == null ||
        response.body['data'] == null ||
        response.body['meta'] == null) {
      throw Exception('Format respons riwayat peminjaman tidak valid');
    }

    return response.body;
  }
}
