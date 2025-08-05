import 'package:briven/features/admin/views/admin_assignments_screen.dart';
import 'package:briven/features/admin/views/admin_devices_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart'; // ← Tambahan penting
import 'features/authentication/views/login_screen.dart';
import 'features/authentication/controllers/login_controller.dart';
import 'features/user/views/dashboard_screen.dart';
import 'features/user/views/devices_list_screen.dart';
import 'features/user/views/profile_screen.dart';
import 'features/user/views/device_detail_screen.dart';
import 'features/admin/views/admin_dashboard_screen.dart';
import 'core/constants/app_routes.dart'; // Tambahan untuk AppRoutes
import 'services/api_service.dart';
import 'features/authentication/views/splash_screen.dart'; // ✅ Tambahkan import ini

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ApiService(), permanent: true);
    Get.put(LoginController(), permanent: true);

    return GetMaterialApp(
      title: 'Asset Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Poppins',
      ),
      initialRoute: '/splash', // ✅ Ganti ke splash
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()), // ✅ Tambah route splash
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/devices', page: () => const DevicesListScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
        GetPage(name: '/device_detail', page: () => const DeviceDetailScreen()),
        GetPage(name: '/admin/dashboard', page: () => const AdminDashboardScreen()),
        GetPage(name: '/admin/devices', page: () => const AdminDevicesScreen()),
        GetPage(name: '/admin-assignments', page: () => const AdminAssignmentsScreen()),

        // Tambahkan semua route dari AppRoutes
        ...AppRoutes.routes,
      ],
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('id', null); // ← Tambahan untuk tanggal lokal
  print('GetStorage diinisialisasi');
  runApp(const MyApp());
}
