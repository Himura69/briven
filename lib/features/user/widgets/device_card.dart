import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../widgets/notification_badge.dart';

class DeviceCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final double width;
  final int? badgeCount;

  const DeviceCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.width,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Container(
      width: width,
      padding: EdgeInsets.all(isWeb ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isWeb ? 40 : 32,
                color: AppColors.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppStyles.body.copyWith(
                  fontSize: isWeb ? 16 : 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppStyles.title.copyWith(
                  fontSize: isWeb ? 24 : 20,
                ),
              ),
            ],
          ),
          if (badgeCount != null)
            Positioned(
              top: 0,
              right: 0,
              child: NotificationBadge(count: badgeCount!),
            ),
        ],
      ),
    );
  }
}
