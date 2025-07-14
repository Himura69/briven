import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../features/user/controllers/dashboard_controller.dart';
import '../../features/user/views/dashboard_screen.dart';
import '../../features/user/views/devices_list_screen.dart';
import '../../features/user/views/profile_screen.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
      title: Text(
        'Asset Management',
        style: AppStyles.title.copyWith(
          color: Colors.white,
          fontSize: isWeb ? 20 : 18,
        ),
      ),
      actions: [
        // Navigasi Home
        isWeb
            ? TextButton.icon(
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
              )
            : IconButton(
                onPressed: () {
                  Get.to(() => const DashboardScreen());
                },
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 20,
                ),
              ),
        // Navigasi My Devices
        isWeb
            ? TextButton.icon(
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
              )
            : IconButton(
                onPressed: () {
                  Get.to(() => const DevicesListScreen());
                },
                icon: Icon(
                  Icons.devices,
                  color: Colors.white,
                  size: 20,
                ),
              ),
        // Navigasi Profile
        isWeb
            ? TextButton.icon(
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
              )
            : IconButton(
                onPressed: () {
                  Get.to(() => const ProfileScreen());
                },
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
        // Teks Selamat Datang
        if (isWeb)
          Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Selamat Datang, ${controller.userName.value}',
                  style: AppStyles.label.copyWith(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ).animate().fadeIn(duration: 600.ms),
              )),
        SizedBox(width: isWeb ? 24 : 8),
      ],
    );
  }
}
