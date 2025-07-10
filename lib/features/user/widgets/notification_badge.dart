import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class NotificationBadge extends StatelessWidget {
  final int count;

  const NotificationBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Container(
      padding: EdgeInsets.all(isWeb ? 8 : 6),
      decoration: const BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
      ),
      child: Text(
        count.toString(),
        style: AppStyles.body.copyWith(
          color: Colors.white,
          fontSize: isWeb ? 14 : 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
