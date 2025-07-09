import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar untuk responsivitas
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600; // Anggap web jika lebar > 600px

    // Menentukan lebar form berdasarkan platform
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
                    'assets/images/logo.png', // Pastikan file ini ada
                    height: isWeb ? 120 : 80,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported,
                        size: isWeb ? 120 : 80,
                        color: AppColors.textSecondary,
                      ); // Fallback jika logo gagal dimuat
                    },
                  ),
                  const SizedBox(height: 32),
                  // Judul
                  Text(
                    'Login to Your Account',
                    style: AppStyles.title.copyWith(
                      fontSize: isWeb ? 28 : 24,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Input Nomor Telepon
                  CustomTextField(
                    hintText: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                  ),
                  const SizedBox(height: 16),
                  // Input Kata Sandi
                  CustomTextField(
                    hintText: 'Password',
                    obscureText: true,
                    prefixIcon: Icons.lock,
                  ),
                  const SizedBox(height: 16),
                  // Remember Me dan Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (value) {
                              // Logika untuk Remember Me (akan ditambahkan nanti)
                            },
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
                          // Navigasi ke Forgot Password (akan ditambahkan nanti)
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
                  CustomButton(
                    text: 'Login',
                    onPressed: () {
                      // Logika login akan ditambahkan nanti
                    },
                    width: double.infinity,
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
