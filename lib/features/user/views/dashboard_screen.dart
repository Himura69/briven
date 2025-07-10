import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/nav_bar.dart';
import '../widgets/device_card.dart';
import '../widgets/notification_badge.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    // Menentukan jumlah kolom grid berdasarkan lebar layar
    final crossAxisCount = isWeb ? 3 : 2;
    final cardWidth = isWeb ? screenWidth * 0.3 : screenWidth * 0.45;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: NavBar(),
      ),
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      body: Padding(
        padding: EdgeInsets.all(isWeb ? 32.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: AppStyles.title.copyWith(
                fontSize: isWeb ? 30 : 24,
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: isWeb ? 24 : 20,
                mainAxisSpacing: isWeb ? 24 : 20,
                childAspectRatio: isWeb ? 1.2 : 1.0,
                children: [
                  DeviceCard(
                    title: 'Assigned Devices',
                    value: '12', // Placeholder, akan diambil dari backend
                    icon: Icons.devices,
                    width: cardWidth,
                    badgeCount: 2, // Notification badge
                  ),
                  DeviceCard(
                    title: 'Active Devices',
                    value: '10',
                    icon: Icons.check_circle,
                    width: cardWidth,
                  ),
                  DeviceCard(
                    title: 'Pending Requests',
                    value: '3',
                    icon: Icons.pending,
                    width: cardWidth,
                    badgeCount: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
