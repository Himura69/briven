import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert'; // Ditambahkan untuk jsonEncode

class ApiService extends GetConnect {
  final String baseUrl = 'http://192.168.2.118:8000/api/v1';
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
      if (token != null && request.url.path != '/auth/login') {
        request.headers['Authorization'] = 'Bearer $token';
      } else if (token == null) {
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

    final data = response.body['data'];
    print('Data login: $data');
    await storage.write('token', data['token'] ?? '');
    await storage.write('role', data['user']?['role'] ?? 'user');
    if (data['user'] != null) {
      await storage.write('user', jsonEncode(data['user']));
    } else {
      print('Data user tidak ditemukan, tidak menyimpan user ke storage');
      await storage.write('user', jsonEncode({}));
    }
    print('Token disimpan: ${storage.read('token')}');
    print('Role disimpan: ${storage.read('role')}');
    print('User disimpan: ${storage.read('user')}');

    return data;
  }

  Future<String?> getRole() async {
    return storage.read('role');
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
    await storage.remove('role');
    await storage.remove('user');
    print('Token, role, dan data user dihapus dari penyimpanan');
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

  Future<Map<String, dynamic>> getAdminKPIs({int? branchId}) async {
    final token = storage.read('token');
    if (token == null) {
      throw Exception('Token autentikasi tidak ditemukan');
    }

    final response = await get(
      '/admin/dashboard/kpis${branchId != null ? '?branchId=$branchId' : ''}',
    );
    print('Respons KPI admin: ${response.bodyString}');
    if (response.status.hasError) {
      final errorMessage =
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'Gagal mengambil KPI: ${response.statusCode}';
      throw Exception(errorMessage);
    }

    if (response.body == null || response.body['data'] == null) {
      throw Exception('Format respons KPI tidak valid');
    }

    return response.body['data'];
  }

  Future<Map<String, dynamic>> getAdminCharts({int? branchId}) async {
    final token = storage.read('token');
    if (token == null) throw Exception('Token autentikasi tidak ditemukan');

    final response = await get(
      '/admin/dashboard/charts${branchId != null ? '?branchId=$branchId' : ''}',
    );
    print('Respons Chart admin: ${response.bodyString}');
    if (response.status.hasError) {
      final errorMessage =
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'Gagal mengambil data Chart: ${response.statusCode}';
      throw Exception(errorMessage);
    }

    if (response.body == null || response.body['data'] == null) {
      throw Exception('Format respons Chart tidak valid');
    }

    return response.body['data'];
  }

  Future<Map<String, dynamic>> getDevicesAdmin({
    String search = '',
    String condition = '',
    int page = 1,
    int perPage = 10,
  }) async {
    final token = storage.read('token');
    if (token == null) {
      throw Exception('Token autentikasi tidak ditemukan');
    }

    final response = await get(
        '/admin/devices?search=$search&condition=$condition&page=$page&perPage=$perPage');

    if (response.status.hasError) {
      final errorMessage =
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'Gagal mengambil daftar perangkat: ${response.statusCode}';
      throw Exception(errorMessage);
    }

    if (response.body == null ||
        response.body['data'] == null ||
        response.body['meta'] == null) {
      throw Exception('Format respons perangkat admin tidak valid');
    }

    return {
      'data': response.body['data'],
      'meta': response.body['meta'],
    };
  }

  Future<Map<String, dynamic>> getDeviceDetailAdmin(int deviceId) async {
    final token = storage.read('token');
    if (token == null) throw Exception('Token autentikasi tidak ditemukan');

    final response = await get('/admin/devices/$deviceId');

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

  Future<void> createDeviceAdmin({
    required String brand,
    required String brandName,
    required String serialNumber,
    required String assetCode,
    required String briboxId,
    required String condition,
    String? spec1,
    String? spec2,
    String? spec3,
    String? spec4,
    String? spec5,
    String? devDate,
  }) async {
    final token = storage.read('token');
    if (token == null) throw Exception('Token autentikasi tidak ditemukan');

    final payload = {
      'brand': brand,
      'brand_name': brandName,
      'serial_number': serialNumber,
      'asset_code': assetCode,
      'bribox_id': briboxId,
      'condition': condition,
      if (spec1 != null) 'spec1': spec1,
      if (spec2 != null) 'spec2': spec2,
      if (spec3 != null) 'spec3': spec3,
      if (spec4 != null) 'spec4': spec4,
      if (spec5 != null) 'spec5': spec5,
      if (devDate != null) 'dev_date': devDate,
    };

    final response = await post('/admin/devices', payload);

    print('Respons tambah perangkat: ${response.bodyString}');
    if (response.status.hasError) {
      final errorMessage =
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'Gagal menambah perangkat: ${response.statusCode}';
      throw Exception(errorMessage);
    }
  }

  Future<void> updateDeviceAdmin({
    required int deviceId,
    String? brand,
    String? brandName,
    String? serialNumber,
    String? assetCode,
    String? briboxId,
    String? condition,
    String? spec1,
    String? spec2,
    String? spec3,
    String? spec4,
    String? spec5,
    String? devDate,
  }) async {
    final token = storage.read('token');
    if (token == null) throw Exception('Token autentikasi tidak ditemukan');

    final payload = {
      if (brand != null) 'brand': brand,
      if (brandName != null) 'brand_name': brandName,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (assetCode != null) 'asset_code': assetCode,
      if (briboxId != null) 'bribox_id': briboxId,
      if (condition != null) 'condition': condition,
      if (spec1 != null) 'spec1': spec1,
      if (spec2 != null) 'spec2': spec2,
      if (spec3 != null) 'spec3': spec3,
      if (spec4 != null) 'spec4': spec4,
      if (spec5 != null) 'spec5': spec5,
      if (devDate != null) 'dev_date': devDate,
    };

    final response = await put('/admin/devices/$deviceId', payload);

    print('Respons update perangkat: ${response.bodyString}');
    if (response.status.hasError) {
      final errorMessage =
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'Gagal memperbarui perangkat: ${response.statusCode}';
      throw Exception(errorMessage);
    }
  }

  Future<void> deleteDeviceAdmin(int deviceId) async {
    final token = storage.read('token');
    if (token == null) throw Exception('Token autentikasi tidak ditemukan');

    final response = await delete('/admin/devices/$deviceId');

    print('Respons hapus perangkat: ${response.bodyString}');
    if (response.status.hasError) {
      final errorMessage =
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'Gagal menghapus perangkat: ${response.statusCode}';
      throw Exception(errorMessage);
    }
  }
}
