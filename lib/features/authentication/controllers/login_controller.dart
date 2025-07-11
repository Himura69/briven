import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../models/user_model.dart';

class LoginController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final pnController = TextEditingController();
  final passwordController = TextEditingController();
  final deviceNameController = TextEditingController(text: 'Flutter Device');
  final isLoading = false.obs;
  final rememberMe = false.obs;

  @override
  void onClose() {
    pnController.dispose();
    passwordController.dispose();
    deviceNameController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (pnController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    try {
      isLoading.value = true;
      final response = await apiService.login(
        pn: pnController.text,
        password: passwordController.text,
        deviceName: deviceNameController.text,
      );

      final user = UserModel.fromJson(response);
      // Simpan token untuk autentikasi selanjutnya (misalnya, menggunakan GetStorage)
      print(
          'Login successful: Token = ${user.token}, User = ${user.name}'); // Logging untuk debugging
      Get.toNamed('/dashboard');
    } catch (e) {
      print('Login error: $e'); // Logging untuk debugging
      String errorMessage = e.toString();
      if (errorMessage.contains('422')) {
        errorMessage =
            'Invalid credentials. Please check your phone number or password.';
      } else if (errorMessage.contains('401')) {
        errorMessage = 'Unauthorized. Please check your credentials.';
      } else if (errorMessage.contains('429')) {
        errorMessage = 'Too many requests. Please try again later.';
      }
      Get.snackbar('Error', errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}
