import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final IconData? icon; // Ikon opsional untuk tombol paginasi

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return SizedBox(
      width: width ?? (isWeb ? 300 : double.infinity),
      child: AnimatedScale(
        scale: onPressed != null ? 1.0 : 0.95, // Efek scale saat dinonaktifkan
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                onPressed != null ? AppColors.primary : Colors.grey[300],
            foregroundColor:
                onPressed != null ? Colors.white : Colors.grey[600],
            padding: EdgeInsets.symmetric(
              vertical: isWeb ? 16 : 12,
              horizontal: icon != null ? 12 : 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: onPressed != null ? 2 : 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: isWeb ? 20 : 18),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: AppStyles.button.copyWith(
                  fontSize: isWeb ? 18 : 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
