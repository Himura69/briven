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
    final isRoot = Get.currentRoute == '/dashboard';

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: !isRoot
          ? IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: isWeb ? 24 : 20,
              ),
            )
          : null,
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
                onPressed: isRoot
                    ? null
                    : () {
                        Get.offAll(() => const DashboardScreen(),
                            predicate: (route) => false);
                      },
                icon: Icon(
                  Icons.home,
                  color: isRoot ? Colors.white54 : Colors.white,
                  size: isWeb ? 24 : 20,
                ),
                label: Text(
                  'Home',
                  style: AppStyles.body.copyWith(
                    color: isRoot ? Colors.white54 : Colors.white,
                    fontSize: isWeb ? 16 : 14,
                  ),
                ),
              )
            : IconButton(
                onPressed: isRoot
                    ? null
                    : () {
                        Get.offAll(() => const DashboardScreen(),
                            predicate: (route) => false);
                      },
                icon: Icon(
                  Icons.home,
                  color: isRoot ? Colors.white54 : Colors.white,
                  size: 20,
                ),
              ),
        // Navigasi My Devices
        isWeb
            ? TextButton.icon(
                onPressed: () {
                  if (Get.currentRoute == '/devices') {
                    Get.back();
                  } else {
                    Get.offNamedUntil('/devices',
                        (route) => route.settings.name == '/dashboard');
                  }
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
                  if (Get.currentRoute == '/devices') {
                    Get.back();
                  } else {
                    Get.offNamedUntil('/devices',
                        (route) => route.settings.name == '/dashboard');
                  }
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
                  if (Get.currentRoute == '/profile') {
                    Get.back();
                  } else {
                    Get.offNamedUntil('/profile',
                        (route) => route.settings.name == '/dashboard');
                  }
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
                  if (Get.currentRoute == '/profile') {
                    Get.back();
                  } else {
                    Get.offNamedUntil('/profile',
                        (route) => route.settings.name == '/dashboard');
                  }
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
