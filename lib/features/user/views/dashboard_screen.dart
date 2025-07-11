import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/nav_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    final contentWidth = isWeb ? screenWidth * 0.6 : screenWidth * 0.9;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: NavBar(),
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isWeb ? 32.0 : 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.summary.value == null
                        ? Center(
                            child: Column(
                              children: [
                                Text(
                                  controller.errorMessage.value.isEmpty
                                      ? 'Failed to load dashboard'
                                      : controller.errorMessage.value,
                                  style: AppStyles.body.copyWith(
                                    fontSize: isWeb ? 16 : 14,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                CustomButton(
                                  text: 'Retry',
                                  onPressed: controller.fetchHomeSummary,
                                  width: isWeb ? 300 : double.infinity,
                                ),
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Pesan Selamat Datang
                              Text(
                                'Selamat datang, ${controller.userName.value}',
                                style: AppStyles.title.copyWith(
                                  fontSize: isWeb ? 28 : 24,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Grid Kartu
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: isWeb ? 2 : 1,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.4,
                                children: [
                                  _buildSummaryCard(
                                    title: 'Active Devices',
                                    value: controller
                                        .summary.value!.activeDevicesCount
                                        .toString(),
                                    icon: Icons.devices,
                                    isWeb: isWeb,
                                  ),
                                  _buildSummaryCard(
                                    title: 'Device History',
                                    value: controller
                                        .summary.value!.deviceHistoryCount
                                        .toString(),
                                    icon: Icons.history,
                                    isWeb: isWeb,
                                  ),
                                ],
                              ),
                            ],
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isWeb,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isWeb ? 40 : 32, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppStyles.body.copyWith(
                fontSize: isWeb ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppStyles.title.copyWith(
                fontSize: isWeb ? 20 : 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
