import 'package:flutter/material.dart';
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
    final isWeb = screenWidth > 600;
    final contentWidth = isWeb ? screenWidth * 0.6 : screenWidth * 0.9;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: NavBar(),
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isWeb ? 32.0 : 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.profile.value == null
                        ? Center(
                            child: Column(
                              children: [
                                Text(
                                  controller.errorMessage.value.isEmpty
                                      ? 'Failed to load profile'
                                      : controller.errorMessage.value,
                                  style: AppStyles.body.copyWith(
                                    fontSize: isWeb ? 16 : 14,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                CustomButton(
                                  text: 'Retry',
                                  onPressed: controller.fetchProfile,
                                  width: isWeb ? 300 : double.infinity,
                                ),
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Profile',
                                style: AppStyles.title.copyWith(
                                  fontSize: isWeb ? 28 : 24,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Avatar
                              CircleAvatar(
                                radius: isWeb ? 60 : 50,
                                backgroundImage: const AssetImage(
                                    'assets/images/avatar.png'),
                                backgroundColor:
                                    AppColors.primary.withOpacity(0.2),
                              ),
                              const SizedBox(height: 16),
                              // Informasi Profil
                              _buildProfileField('Name',
                                  controller.profile.value!.name, isWeb),
                              _buildProfileField('Phone Number',
                                  controller.profile.value!.pn, isWeb),
                              _buildProfileField('Department',
                                  controller.profile.value!.department, isWeb),
                              _buildProfileField('Branch',
                                  controller.profile.value!.branch, isWeb),
                              _buildProfileField('Position',
                                  controller.profile.value!.position, isWeb),
                              const SizedBox(height: 24),
                              // Tombol Ubah Kata Sandi
                              CustomButton(
                                text: 'Change Password',
                                onPressed: () {
                                  Get.snackbar('Info',
                                      'Change Password not implemented yet');
                                },
                                width: isWeb ? 300 : double.infinity,
                              ),
                              const SizedBox(height: 16),
                              // Tombol Logout
                              CustomButton(
                                text: 'Logout',
                                onPressed: () {
                                  controller.logout();
                                },
                                width: isWeb ? 300 : double.infinity,
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

  Widget _buildProfileField(String label, String value, bool isWeb) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.body.copyWith(
              fontSize: isWeb ? 16 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AppStyles.body.copyWith(
                fontSize: isWeb ? 16 : 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
