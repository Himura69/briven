import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  static final TextStyle title = TextStyle(
    fontFamily: 'Poppins', // Gunakan font modern
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle body = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static final TextStyle button = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Gaya baru untuk label dan sublabel
  static final TextStyle label = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final TextStyle sublabel = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    color: AppColors.textSecondary,
  );
}
