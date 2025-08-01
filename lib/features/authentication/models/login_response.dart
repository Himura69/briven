import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_service.dart';
import '../models/user_model.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find<LoginController>();
  final ApiService apiService = Get.find<ApiService>();
  final GetStorage storage = GetStorage();
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
      Get.snackbar('Error', 'Harap isi semua kolom');
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
      await storage.write('user', user.toJson());
      
      print('Token tersimpan: ${storage.read('token')}'); // Log token
      print('Data user tersimpan: ${storage.read('user')}'); // Log user data
      Get.offNamed('/dashboard');
    } catch (e) {
      print('Error login: $e');
      String errorMessage = e.toString();
      if (errorMessage.contains('422')) {
        errorMessage =
            'Kredensial tidak valid. Periksa nomor telepon atau kata sandi Anda.';
      } else if (errorMessage.contains('401')) {
        errorMessage = 'Tidak diizinkan. Periksa kredensial Anda.';
      } else if (errorMessage.contains('429')) {
        errorMessage = 'Terlalu banyak permintaan. Coba lagi nanti.';
      }
      Get.snackbar('Error', errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}
