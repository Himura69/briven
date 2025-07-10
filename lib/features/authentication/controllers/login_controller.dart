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
      // Untuk saat ini, kita langsung navigasi
      Get.toNamed('/dashboard');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
