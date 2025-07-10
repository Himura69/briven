import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/nav_bar.dart';

class DevicesListScreen extends StatelessWidget {
  const DevicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: NavBar(),
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'My Devices (Placeholder)',
          style: AppStyles.title,
        ),
      ),
    );
  }
}
