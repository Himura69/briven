import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import 'admin_dashboard_screen.dart';
import 'admin_devices_screen.dart';
import 'user_management_screen.dart';
import 'admin_assignments_screen.dart';
import '../../../services/api_service.dart';

class AdminRootScreen extends StatefulWidget {
  const AdminRootScreen({super.key});

  @override
  State<AdminRootScreen> createState() => _AdminRootScreenState();
}

class _AdminRootScreenState extends State<AdminRootScreen> {
  int _selectedIndex = 0;
  final ApiService apiService = Get.find<ApiService>();

  final List<Widget> _pages = const [
    AdminDashboardScreen(),
    AdminDevicesScreen(),
    AdminAssignmentsScreen(),
    UserManagementScreen(),
  ];

  final List<String> _titles = const [
    'Dashboard Admin',
    'Device Management',
    'Device Assignments',
    'User Management',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    try {
      await apiService.logout();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Gagal logout: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _openQrScanner() {
    Get.toNamed('/qr-scan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        titleSpacing: 16,
        centerTitle: false,
        title: Row(
          children: [
            Icon(
              _selectedIndex == 0
                  ? Icons.dashboard_rounded
                  : _selectedIndex == 1
                      ? Icons.devices_other_rounded
                      : _selectedIndex == 2
                          ? Icons.assignment_ind_rounded
                          : Icons.people_alt_rounded,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              _titles[_selectedIndex],
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _openQrScanner,
        backgroundColor: Colors.blueAccent,
        tooltip: 'Scan QR',
        shape: const CircleBorder(),
        elevation: 6,
        child: const Icon(Icons.qr_code_scanner, size: 36, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle:
            const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices_other_rounded),
            label: 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_ind_rounded),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}
