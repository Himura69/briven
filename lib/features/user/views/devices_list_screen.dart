import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/nav_bar.dart';
import '../widgets/filter_chip_widget.dart';
import 'device_detail_screen.dart';

class DevicesListScreen extends StatelessWidget {
  const DevicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: NavBar(),
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(isWeb ? 32.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Devices',
              style: AppStyles.title.copyWith(
                fontSize: isWeb ? 28 : 24,
              ),
            ),
            const SizedBox(height: 16),
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search devices...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 16 : 12,
                  vertical: isWeb ? 14 : 10,
                ),
              ),
              style: AppStyles.body.copyWith(
                fontSize: isWeb ? 16 : 14,
              ),
            ),
            const SizedBox(height: 16),
            // Filter Chips
            Wrap(
              spacing: isWeb ? 12 : 8,
              children: [
                FilterChipWidget(label: 'Active', isSelected: true),
                FilterChipWidget(label: 'Returned', isSelected: false),
                FilterChipWidget(label: 'Good', isSelected: false),
                FilterChipWidget(label: 'Damaged', isSelected: false),
                FilterChipWidget(label: 'Needs Repair', isSelected: false),
              ],
            ),
            const SizedBox(height: 16),
            // Device List
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Placeholder
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(
                      vertical: isWeb ? 12 : 8,
                      horizontal: 4,
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(isWeb ? 16 : 12),
                      leading: Icon(
                        Icons.devices,
                        size: isWeb ? 40 : 32,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        'Device ${index + 1}', // Placeholder
                        style: AppStyles.title.copyWith(
                          fontSize: isWeb ? 18 : 16,
                        ),
                      ),
                      subtitle: Text(
                        'Status: Active | Condition: Good', // Placeholder
                        style: AppStyles.body.copyWith(
                          fontSize: isWeb ? 14 : 12,
                        ),
                      ),
                      onTap: () {
                        Get.toNamed('/device_detail');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
