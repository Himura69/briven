import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../admin/views/admin_root_screen.dart';

class RoleRouter extends StatelessWidget {
  final GetStorage storage = GetStorage();

  RoleRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final String? role = storage.read('role');
    if (role == 'admin') {
      return AdminRootScreen(); // admin langsung ke root nav
    } else {
      return const Placeholder(); 
      // ganti dengan UserDashboardScreen() atau splash
    }
  }
}
