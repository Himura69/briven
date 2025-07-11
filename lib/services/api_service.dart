import 'package:get/get.dart';

class ApiService extends GetConnect {
  final String baseUrl = 'http://192.168.2.216:8000/api/v1';

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
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
      final errorMessage =
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'Login failed: ${response.statusCode}';
      throw Exception(errorMessage);
    }

    if (response.body == null || response.body['data'] == null) {
      throw Exception('Invalid response format from server');
    }

    return response.body['data'];
  }
}
