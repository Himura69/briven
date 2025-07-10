import 'package:get/get.dart';

class ApiService extends GetConnect {
  final String baseUrl = 'http://192.168.2.230:8000/api/v1';

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
      // Tambahkan X-Device-Info sesuai kebutuhan
      request.headers['X-Device-Info'] = 'Flutter App, v1.0.0';
      return request;
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

    if (response.status.hasError) {
      throw Exception(response.body['message'] ?? 'Login failed');
    }
    return response.body['data'];
  }
}
