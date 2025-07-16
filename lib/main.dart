import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'features/authentication/views/login_screen.dart';
import 'features/user/views/dashboard_screen.dart';
import 'features/user/views/devices_list_screen.dart';
import 'features/user/views/profile_screen.dart';
import 'features/user/views/device_detail_screen.dart';
import 'features/admin/views/admin_dashboard_screen.dart';
import 'services/api_service.dart';
import 'features/authentication/controllers/login_controller.dart';
import 'features/user/controllers/dashboard_controller.dart';
import 'features/user/controllers/devices_list_controller.dart';
import 'features/user/controllers/profile_controller.dart';
import 'features/user/controllers/device_detail_controller.dart';
import 'features/user/controllers/loan_history_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  print('GetStorage diinisialisasi');

  // Inisialisasi controller
  Get.put(ApiService(), permanent: true);
  Get.put(LoginController());
  Get.put(DashboardController());
  Get.put(DevicesListController());
  Get.put(ProfileController());
  Get.put(DeviceDetailController());
  Get.put(LoanHistoryController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Asset Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Poppins',
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/devices', page: () => const DevicesListScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
        GetPage(name: '/device_detail', page: () => const DeviceDetailScreen()),
        GetPage(
            name: '/admin/dashboard', page: () => const AdminDashboardScreen()),
      ],
    );
  }
}
