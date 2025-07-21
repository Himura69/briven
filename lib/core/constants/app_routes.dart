import 'package:get/get.dart';
import '../../features/admin/views/admin_dashboard_screen.dart';
import '../../features/admin/views/admin_devices_screen.dart';
import '../../features/admin/views/device_form_screen.dart';
import '../../features/admin/views/admin_root_screen.dart';

class AppRoutes {
  // Nama route
  static const String adminRoot = '/admin/root';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminDevices = '/admin/devices';
  static const String adminDeviceForm = '/admin/device-form';

  // Semua route didaftarkan di sini
  static final routes = [
    GetPage(
      name: adminRoot,
      page: () => const AdminRootScreen(),
    ),
    GetPage(
      name: adminDashboard,
      page: () => const AdminDashboardScreen(),
    ),
    GetPage(
      name: adminDevices,
      page: () => const AdminDevicesScreen(),
    ),
    GetPage(
      name: adminDeviceForm,
      page: () => DeviceFormScreen(),
    ),
  ];
}
