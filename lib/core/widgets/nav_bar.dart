import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../../features/user/views/dashboard_screen.dart';
import '../../features/user/views/devices_list_screen.dart';
import '../../features/user/views/profile_screen.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      title: Text(
        'Asset Management',
        style: AppStyles.title.copyWith(
          color: Colors.white,
          fontSize: isWeb ? 20 : 18,
        ),
      ),
      actions: [
        // Navigasi Home
        TextButton.icon(
          onPressed: () {
            Get.to(() => const DashboardScreen());
          },
          icon: Icon(
            Icons.home,
            color: Colors.white,
            size: isWeb ? 24 : 20,
          ),
          label: Text(
            'Home',
            style: AppStyles.body.copyWith(
              color: Colors.white,
              fontSize: isWeb ? 16 : 14,
            ),
          ),
        ),
        // Navigasi My Devices
        TextButton.icon(
          onPressed: () {
            Get.to(() => const DevicesListScreen());
          },
          icon: Icon(
            Icons.devices,
            color: Colors.white,
            size: isWeb ? 24 : 20,
          ),
          label: Text(
            'My Devices',
            style: AppStyles.body.copyWith(
              color: Colors.white,
              fontSize: isWeb ? 16 : 14,
            ),
          ),
        ),
        // Navigasi Profile
        TextButton.icon(
          onPressed: () {
            Get.to(() => const ProfileScreen());
          },
          icon: Icon(
            Icons.person,
            color: Colors.white,
            size: isWeb ? 24 : 20,
          ),
          label: Text(
            'Profile',
            style: AppStyles.body.copyWith(
              color: Colors.white,
              fontSize: isWeb ? 16 : 14,
            ),
          ),
        ),
        SizedBox(width: isWeb ? 24 : 16),
      ],
    );
  }
}
