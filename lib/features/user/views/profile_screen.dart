import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/nav_bar.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 900;
    final isTablet = screenWidth >= 600 && screenWidth <= 900;
    final contentWidth = isWeb ? screenWidth * 0.6 : screenWidth * 0.9;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: NavBar(),
      ),
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              AppColors.gradientEnd.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb
                  ? 32.0
                  : isTablet
                      ? 24.0
                      : 16.0,
              vertical: isWeb
                  ? 32.0
                  : isTablet
                      ? 24.0
                      : 16.0,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Loading State
                    Obx(
                      () => controller.isLoading.value
                          ? Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: SpinKitDoubleBounce(
                                color: AppColors.primary,
                                size: isWeb
                                    ? 60
                                    : isTablet
                                        ? 50
                                        : 40,
                              ),
                            ).animate().fadeIn(duration: 500.ms)
                          : controller.profile.value == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 16),
                                    Icon(
                                      Icons.error_outline,
                                      size: isWeb
                                          ? 80
                                          : isTablet
                                              ? 70
                                              : 60,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      controller.errorMessage.value.isEmpty
                                          ? 'Failed to load profile'
                                          : controller.errorMessage.value,
                                      style: AppStyles.body.copyWith(
                                        fontSize: isWeb
                                            ? 16
                                            : isTablet
                                                ? 15
                                                : 14,
                                        color: AppColors.textSecondary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomButton(
                                      text: 'Retry',
                                      icon: Icons.refresh,
                                      onPressed: controller.fetchProfile,
                                      width: isWeb ? 300 : contentWidth * 0.8,
                                    ),
                                  ],
                                ).animate().fadeIn(duration: 500.ms)
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Kartu Profil
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: AppColors.primary
                                              .withOpacity(0.5),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.gradientStart,
                                                AppColors.gradientEnd,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildProfileField(
                                                'Name',
                                                controller
                                                        .profile.value!.name ??
                                                    'Unknown',
                                                Icons.person,
                                                isWeb,
                                                isTablet,
                                              ),
                                              const Divider(
                                                color: Colors.white24,
                                                thickness: 1,
                                                height: 16,
                                              ),
                                              _buildProfileField(
                                                'Phone Number',
                                                controller.profile.value!.pn ??
                                                    '',
                                                Icons.phone,
                                                isWeb,
                                                isTablet,
                                              ),
                                              const Divider(
                                                color: Colors.white24,
                                                thickness: 1,
                                                height: 16,
                                              ),
                                              _buildProfileField(
                                                'Department',
                                                controller.profile.value!
                                                        .department ??
                                                    'Unknown',
                                                Icons.business,
                                                isWeb,
                                                isTablet,
                                              ),
                                              const Divider(
                                                color: Colors.white24,
                                                thickness: 1,
                                                height: 16,
                                              ),
                                              _buildProfileField(
                                                'Branch',
                                                controller.profile.value!
                                                        .branch ??
                                                    'Unknown',
                                                Icons.location_on,
                                                isWeb,
                                                isTablet,
                                              ),
                                              const Divider(
                                                color: Colors.white24,
                                                thickness: 1,
                                                height: 16,
                                              ),
                                              _buildProfileField(
                                                'Position',
                                                controller.profile.value!
                                                        .position ??
                                                    'Unknown',
                                                Icons.work,
                                                isWeb,
                                                isTablet,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ).animate().fadeIn(duration: 600.ms).slideY(
                                          begin: 0.2,
                                          end: 0,
                                          duration: 600.ms,
                                          curve: Curves.easeOut,
                                        ),
                                    const SizedBox(height: 24),
                                    // Tombol Ubah Kata Sandi
                                    CustomButton(
                                      text: 'Change Password',
                                      icon: Icons.lock,
                                      onPressed: () {
                                        Get.snackbar('Info',
                                            'Change Password not implemented yet');
                                      },
                                      width: isWeb ? 300 : contentWidth * 0.8,
                                    ).animate().fadeIn(duration: 600.ms).scale(
                                          duration: 600.ms,
                                          curve: Curves.easeOut,
                                        ),
                                    const SizedBox(height: 16),
                                    // Tombol Logout
                                    CustomButton(
                                      text: 'Logout',
                                      icon: Icons.logout,
                                      onPressed: controller.logout,
                                      width: isWeb ? 300 : contentWidth * 0.8,
                                    ).animate().fadeIn(duration: 600.ms).scale(
                                          duration: 600.ms,
                                          curve: Curves.easeOut,
                                        ),
                                  ],
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(
      String label, String value, IconData icon, bool isWeb, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: isWeb
                ? 24
                : isTablet
                    ? 22
                    : 20,
            color: Colors.white, // Warna ikon diubah ke putih
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyles.body.copyWith(
                    fontSize: isWeb
                        ? 16
                        : isTablet
                            ? 15
                            : 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppStyles.body.copyWith(
                    fontSize: isWeb
                        ? 16
                        : isTablet
                            ? 15
                            : 14,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
