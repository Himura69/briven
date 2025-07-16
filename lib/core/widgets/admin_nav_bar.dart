import 'package:briven/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';

class AdminNavBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminNavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 900;
    final isTablet = screenWidth >= 600 && screenWidth <= 900;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Asset Management',
          style: AppStyles.title.copyWith(
            fontSize: isWeb
                ? 20
                : isTablet
                    ? 18
                    : 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          _buildNavItem(
              context, 'Dashboard', '/admin/dashboard', isWeb, isTablet),
          _buildNavItem(context, 'Devices', '/admin/devices', isWeb, isTablet),
          _buildNavItem(context, 'Users', '/admin/users', isWeb, isTablet),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await Get.find<ApiService>().logout();
              Get.offAllNamed('/login');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String title,
    String route,
    bool isWeb,
    bool isTablet,
  ) {
    final isSelected = Get.currentRoute == route;
    return TextButton(
      onPressed: () => Get.toNamed(route),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontSize: isWeb
              ? 16
              : isTablet
                  ? 15
                  : 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
