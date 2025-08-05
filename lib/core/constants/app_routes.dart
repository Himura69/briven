import 'package:briven/features/admin/views/admin_profile.dart';
import 'package:briven/features/admin/views/qr_scanner_screen.dart';
import 'package:briven/features/admin/views/qr_scan_result_screen.dart';
import 'package:get/get.dart';
import '../../features/admin/views/admin_dashboard_screen.dart';
import '../../features/admin/views/admin_devices_screen.dart';
import '../../features/admin/views/device_form_screen.dart';
import '../../features/admin/views/admin_root_screen.dart';
import '../../features/admin/views/admin_assignments_screen.dart';
import '../../features/admin/controllers/qr_scanner_controller.dart';

class AppRoutes {
  static const String adminRoot = '/admin/root';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminDevices = '/admin/devices';
  static const String adminDeviceForm = '/admin/device-form';
  static const String adminAssignments = '/admin-assignments';
  static const String qrScanner = '/qr-scan';
  static const String qrScanResult = '/qr-scan-result';
  static const String adminProfile = '/admin-profile';

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
    GetPage(
      name: adminAssignments,
      page: () => const AdminAssignmentsScreen(),
    ),
    GetPage(
      name: qrScanner,
      page: () => const QrScannerScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => QrScannerController());
      }),
    ),
    GetPage(
      name: qrScanResult,
      page: () => const QrScanResultScreen(),
      binding: BindingsBuilder(() {
        // Bind again to ensure controller is available here
        Get.lazyPut(() => QrScannerController());
      }),
    ),
    GetPage(
      name: adminProfile,
      page: () => const AdminProfileScreen(),
    ),
  ];
}
