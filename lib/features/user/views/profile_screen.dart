import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Column(
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
                        'assets/images/briven.png'), // Ganti dengan path avatar
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  // Informasi Profil
                  _buildProfileField('Name', 'John Doe', isWeb),
                  _buildProfileField('Position', 'Staff', isWeb),
                  _buildProfileField('Department', 'IT Department', isWeb),
                  _buildProfileField('Branch', 'Main Branch', isWeb),
                  _buildProfileField('Account Role', 'User', isWeb),
                  const SizedBox(height: 24),
                  // Tombol Ubah Kata Sandi
                  CustomButton(
                    text: 'Change Password',
                    onPressed: () {
                      // Logika ubah kata sandi
                    },
                    width: isWeb ? 300 : double.infinity,
                  ),
                  const SizedBox(height: 16),
                  // Tombol Logout
                  CustomButton(
                    text: 'Logout',
                    onPressed: () {
                      Get.offAllNamed('/login'); // Kembali ke LoginScreen
                    },
                    width: isWeb ? 300 : double.infinity,
                  ),
                ],
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
          Text(
            value,
            style: AppStyles.body.copyWith(
              fontSize: isWeb ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
