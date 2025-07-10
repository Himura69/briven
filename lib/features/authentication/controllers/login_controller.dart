import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_service.dart';
import '../models/user_model.dart';

class LoginController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final GetStorage storage = GetStorage();
  final pnController = TextEditingController();
  final passwordController = TextEditingController();
  final deviceNameController = TextEditingController(text: 'Flutter Device');
  final isLoading = false.obs;
  final rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Muat status "Remember me" dari penyimpanan
    if (storage.hasData('rememberMe')) {
      rememberMe.value = storage.read('rememberMe');
    }
  }

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

      // Simpan token dan data pengguna jika "Remember me" dicentang
      if (rememberMe.value) {
        await storage.write('token', user.token);
        await storage.write('user', user.toJson());
        await storage.write('rememberMe', true);
      } else {
        await storage.remove('token');
        await storage.remove('user');
        await storage.write('rememberMe', false);
      }

      Get.toNamed('/dashboard');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
