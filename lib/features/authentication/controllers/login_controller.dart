import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_service.dart';
import '../models/user_model.dart';
import '../../admin/views/admin_root_screen.dart'; // Tambah import untuk root admin

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
  void onInit() {
    super.onInit();
    GetStorage.init()
        .then((_) => print('GetStorage diinisialisasi di LoginController'));
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
      print('Respons login mentah: $response');

      final user = UserModel.fromJson(response['user'] ?? {});
      final token = response['token'] ?? '';
      if (token.isEmpty) {
        throw Exception('Token tidak ditemukan di respons login');
      }

      // Simpan token & role
      await storage.write('token', token);
      await storage.write('role', user.role ?? 'user');
      await storage.write('user', user.toJson());

      print('Login berhasil: Token = $token, User = ${user.name}, Role = ${user.role}');
      print('Token tersimpan: ${storage.read('token')}');
      print('Role tersimpan: ${storage.read('role')}');

      // Arahkan ke halaman sesuai role
      if (user.role == 'admin') {
        Get.offAll(() => AdminRootScreen()); // langsung ke root admin
      } else {
        Get.offAllNamed('/dashboard');
      }
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
      } else {
        errorMessage = 'Gagal login: $e';
      }
      Get.snackbar('Error', errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}
