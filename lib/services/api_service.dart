import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert'; // Ditambahkan untuk jsonEncode
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// untuk basename()

class ApiService extends GetConnect {
  final String baseUrl = 'http://192.168.18.22:8000/api/v1';
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

  Future<Map<String, dynamic>> getAdminDevices({
    String? search,
    String? condition,
    int page = 1,
    int perPage = 20,
  }) async {
    final query = [
      if (search != null) 'search=$search',
      if (condition != null) 'condition=$condition',
      'page=$page',
      'perPage=$perPage'
    ].join('&');

    final response = await get('/admin/devices?$query');
    if (response.status.hasError) {
      throw Exception(response.body?['message'] ?? 'Gagal mengambil perangkat');
    }
    return response.body ?? {};
  }

  Future<Map<String, dynamic>> getAdminDeviceDetail(int deviceId) async {
    final response = await get('/admin/devices/$deviceId');
    if (response.status.hasError) {
      throw Exception(
          response.body?['message'] ?? 'Gagal mengambil detail perangkat');
    }
    return response.body?['data'] ?? {};
  }

  Future<Map<String, dynamic>> createAdminDevice(
      Map<String, dynamic> payload) async {
    final response = await post('/admin/devices', payload);
    if (response.status.hasError) {
      throw Exception(response.body?['message'] ?? 'Gagal menambah perangkat');
    }
    return response.body?['data'] ?? {};
  }

  Future<Map<String, dynamic>> updateAdminDevice(
      int id, Map<String, dynamic> payload) async {
    final response = await put('/admin/devices/$id', payload);
    if (response.status.hasError) {
      throw Exception(
          response.body?['message'] ?? 'Gagal memperbarui perangkat');
    }
    return response.body?['data'] ?? {};
  }

  Future<void> deleteAdminDevice(int id) async {
    final response = await delete('/admin/devices/$id');
    if (response.status.hasError) {
      final errorCode = response.body?['errorCode'];
      if (errorCode == 'ERR_DEVICE_ASSIGNED') {
        throw Exception('Tidak bisa menghapus: perangkat sedang dipinjam');
      }
      throw Exception(response.body?['message'] ?? 'Gagal menghapus perangkat');
    }
  }

  Future<Map<String, dynamic>> getDeviceFormOptions(
      {String? field, String? search}) async {
    final query = [
      if (field != null) 'field=$field',
      if (search != null) 'search=$search',
    ].join('&');

    final response = await get(
        '/admin/devices/form-options${query.isNotEmpty ? '?$query' : ''}');
    if (response.status.hasError) {
      throw Exception(
          response.body?['message'] ?? 'Gagal mengambil form options');
    }
    return response.body?['data'] ?? {};
  }

  Future<Map<String, dynamic>> getDeviceValidationRules() async {
    final response = await get('/admin/form-options/validation/devices');
    if (response.status.hasError) {
      throw Exception(
          response.body?['message'] ?? 'Gagal mengambil validation rules');
    }
    return response.body?['data'] ?? {};
  }

  // Tambahan di ApiService
  Future<Map<String, dynamic>> getAdminAssignments({
    String? search,
    String? status,
    int? branchId,
    bool activeOnly = false,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = [
      if (search != null && search.isNotEmpty) 'search=$search',
      if (status != null && status.isNotEmpty) 'status=$status',
      if (branchId != null) 'branchId=$branchId',
      if (activeOnly) 'activeOnly=true',
      'page=$page',
      'perPage=$perPage',
    ].join('&');

    final response = await get('/admin/device-assignments?$queryParams');
    if (response.status.hasError) {
      throw Exception(
          response.body?['message'] ?? 'Gagal mengambil assignments');
    }
    return response.body ?? {};
  }

  Future<Map<String, dynamic>> getAdminAssignmentDetail(int id) async {
    final response = await get('/admin/device-assignments/$id');
    if (response.status.hasError) {
      throw Exception(
          response.body?['message'] ?? 'Gagal mengambil detail assignment');
    }
    return response.body?['data'] ?? {};
  }

  Future<Map<String, dynamic>> createAdminAssignment(
      Map<String, dynamic> payload) async {
    final response = await post('/admin/device-assignments', payload);
    if (response.status.hasError) {
      throw Exception(response.body?['message'] ?? 'Gagal membuat assignment');
    }
    return response.body?['data'] ?? {};
  }

  Future<Map<String, dynamic>> updateAdminAssignment(
      int id, Map<String, dynamic> payload) async {
    final response = await put('/admin/device-assignments/$id', payload);
    if (response.status.hasError) {
      throw Exception(
          response.body?['message'] ?? 'Gagal memperbarui assignment');
    }
    return response.body?['data'] ?? {};
  }

  Future<Map<String, dynamic>> returnAdminAssignment(
      int id, Map<String, dynamic> payload) async {
    final response =
        await post('/admin/device-assignments/$id/return', payload);
    if (response.status.hasError) {
      throw Exception(
          response.body?['message'] ?? 'Gagal mengembalikan perangkat');
    }
    return response.body?['data'] ?? {};
  }

  Future<Map<String, dynamic>> getAssignmentFormOptions({
    String? field,
    String? search,
  }) async {
    final query = [
      if (field != null) 'field=$field',
      if (search != null) 'search=$search',
    ].join('&');

    final response = await get(
      '/admin/device-assignments/form-options${query.isNotEmpty ? '?$query' : ''}',
    );
    if (response.status.hasError) {
      throw Exception(
          response.body?['message'] ?? 'Gagal mengambil opsi form assignment');
    }
    return response.body?['data'] ?? {};
  }

  Future<Map<String, dynamic>> getAssignmentValidationRules() async {
    final response =
        await get('/admin/form-options/validation/device-assignments');
    if (response.status.hasError) {
      throw Exception(response.body?['message'] ??
          'Gagal mengambil aturan validasi assignment');
    }
    return response.body?['data'] ?? {};
  }

  Future<Map<String, dynamic>> createAdminAssignmentMultipart(
      Map<String, dynamic> payload) async {
    final form = FormData({});

    payload.forEach((key, value) {
      if (key == 'letter_file' && value is File) {
        form.files.add(MapEntry(
          'letter_file',
          MultipartFile(value, filename: basename(value.path)),
        ));
      } else if (value != null) {
        form.fields.add(MapEntry(key, value.toString()));
      }
    });

    final response = await post('/admin/device-assignments', form);
    if (response.status.hasError) {
      throw Exception(
          response.body?['message'] ?? 'Gagal membuat assignment (multipart)');
    }
    return response.body?['data'] ?? {};
  }

  Future<Map<String, dynamic>> updateAdminAssignmentMultipart(
      int id, Map<String, dynamic> payload) async {
    final form = FormData({});

    payload.forEach((key, value) {
      if (key == 'letter_file' && value is File) {
        form.files.add(MapEntry(
          'letter_file',
          MultipartFile(value, filename: basename(value.path)),
        ));
      } else if (value != null) {
        form.fields.add(MapEntry(key, value.toString()));
      }
    });

    final response = await put('/admin/device-assignments/$id', form);
    if (response.status.hasError) {
      throw Exception(response.body?['message'] ??
          'Gagal memperbarui assignment (multipart)');
    }
    return response.body?['data'] ?? {};
  }
}
