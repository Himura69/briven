import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Ubah dari VoidCallback ke VoidCallback?
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed, // Sekarang nullable
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return SizedBox(
      width: width ?? (isWeb ? 300 : double.infinity),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(
            vertical: isWeb ? 16 : 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: AppStyles.button.copyWith(
            fontSize: isWeb ? 18 : 16,
          ),
        ),
      ),
    );
  }
}
