import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'features/authentication/views/login_screen.dart';
import 'features/user/views/dashboard_screen.dart';
import 'features/user/views/devices_list_screen.dart';
import 'features/user/views/profile_screen.dart';
import 'features/user/views/device_detail_screen.dart';
import 'services/api_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi ApiService
    Get.put(ApiService());

    // Tentukan rute awal berdasarkan token
    final GetStorage storage = GetStorage();
    final initialRoute = storage.hasData('token') ? '/dashboard' : '/login';

    return GetMaterialApp(
      title: 'Asset Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/devices', page: () => const DevicesListScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
        GetPage(name: '/device_detail', page: () => const DeviceDetailScreen()),
      ],
    );
  }
}

void main() async {
  // Inisialisasi GetStorage sebelum runApp
  await GetStorage.init();
  runApp(const MyApp());
}
