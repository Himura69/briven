import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller dengan tag permanen agar tidak dihapus saat navigasi
    final LoginController controller =
        Get.put(LoginController(), permanent: true);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    final formWidth = isWeb ? screenWidth * 0.4 : screenWidth * 0.9;
    final padding = isWeb ? 32.0 : 16.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: formWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: isWeb ? 120 : 150,
                  ),
                  const SizedBox(height: 32),
                  // Judul
                  Text(
                    'Login to Your Account',
                    style: AppStyles.title.copyWith(
                      fontSize: isWeb ? 28 : 20,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Input Nomor Telepon
                  CustomTextField(
                    hintText: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                    controller: controller.pnController,
                  ),
                  const SizedBox(height: 16),
                  // Input Kata Sandi
                  CustomTextField(
                    hintText: 'Password',
                    obscureText: true,
                    prefixIcon: Icons.lock,
                    controller: controller.passwordController,
                  ),
                  const SizedBox(height: 16),
                  // Remember Me dan Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (value) {
                                controller.rememberMe.value = value ?? false;
                              },
                            ),
                          ),
                          Text(
                            'Remember me',
                            style: AppStyles.body.copyWith(
                              fontSize: isWeb ? 16 : 14,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Get.snackbar(
                              'Info', 'Forgot Password not implemented yet');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: AppStyles.body.copyWith(
                            color: AppColors.primary,
                            fontSize: isWeb ? 16 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Tombol Login
                  Obx(
                    () => controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            text: 'Login',
                            onPressed: () {
                              controller.login();
                            },
                            width: double.infinity,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
