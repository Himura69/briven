import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/api_service.dart';

class AdminNavBar extends StatelessWidget {
  final ApiService apiService = Get.find<ApiService>();

  AdminNavBar({super.key});

  Future<void> _logout() async {
    try {
      await apiService.logout();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Gagal logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: const Text(
        'Admin Panel',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.toNamed('/admin/dashboard'),
          child: const Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Get.toNamed('/admin/devices'),
          child: const Text(
            'Devices',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: _logout,
          child: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
