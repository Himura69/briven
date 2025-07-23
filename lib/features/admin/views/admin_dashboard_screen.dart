import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../../../../core/widgets/admin_nav_bar.dart';
import '../../../../../core/widgets/kpi_card.dart';
import '../../../../../core/widgets/activity_log_card.dart';
import '../../../../../core/widgets/device_condition_chart.dart';
import '../../../../../core/widgets/branch_distribution_chart.dart';
import '../../admin/controllers/admin_dashboard_controller.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 900;
    final isTablet = screenWidth >= 600 && screenWidth <= 900;
    final contentWidth = isWeb ? screenWidth * 0.7 : screenWidth * 0.95;

    final controller = Get.put(AdminDashboardController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AdminNavBar(),
      ),
      backgroundColor: const Color(0xFFF8F9FB), // Background soft abu-abu
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isWeb
              ? 32.0
              : isTablet
                  ? 24.0
                  : 16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    const Icon(Icons.dashboard_rounded,
                        size: 28, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Dashboard Admin',
                      style: AppStyles.title.copyWith(
                        fontSize: isWeb
                            ? 26
                            : isTablet
                                ? 24
                                : 22,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // KPI SECTION
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.errorMessage.isNotEmpty) {
                    return Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.redAccent),
                    );
                  }
                  if (controller.kpiData.value == null) {
                    return const Text(
                      'Tidak ada data KPI',
                      style: TextStyle(color: Colors.black54),
                    );
                  }

                  final kpi = controller.kpiData.value!;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      KpiCard(
                        title: 'Total Devices',
                        value: kpi.totalDevices.toString(),
                        color: Colors.blueAccent,
                      ),
                      KpiCard(
                        title: 'In Use',
                        value: kpi.inUse.toString(),
                        color: Colors.green,
                      ),
                      KpiCard(
                        title: 'Available',
                        value: kpi.available.toString(),
                        color: Colors.orange,
                      ),
                      KpiCard(
                        title: 'Damaged',
                        value: kpi.damaged.toString(),
                        color: Colors.redAccent,
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 36),

                // DEVICE CONDITION CHART
                Row(
                  children: [
                    const Icon(Icons.pie_chart_rounded,
                        size: 22, color: Colors.blueAccent),
                    const SizedBox(width: 6),
                    Text(
                      'Kondisi Perangkat',
                      style: AppStyles.title.copyWith(
                        fontSize: isWeb
                            ? 20
                            : isTablet
                                ? 18
                                : 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final chart = controller.chartData.value;
                  if (chart == null || chart.deviceConditions.isEmpty) {
                    return const Text(
                      'Tidak ada data kondisi perangkat.',
                      style: TextStyle(color: Colors.black54),
                    );
                  }
                  return Center(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 300,
                          child: DeviceConditionChart(
                              data: chart.deviceConditions),
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 36),

                // BRANCH DISTRIBUTION CHART
                Row(
                  children: [
                    const Icon(Icons.bar_chart_rounded,
                        size: 22, color: Colors.blueAccent),
                    const SizedBox(width: 6),
                    Text(
                      'Distribusi Perangkat per Cabang',
                      style: AppStyles.title.copyWith(
                        fontSize: isWeb
                            ? 20
                            : isTablet
                                ? 18
                                : 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final chart = controller.chartData.value;
                  if (chart == null || chart.devicesPerBranch.isEmpty) {
                    return const Text(
                      'Tidak ada data distribusi cabang.',
                      style: TextStyle(color: Colors.black54),
                    );
                  }
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child:
                          BranchDistributionChart(data: chart.devicesPerBranch),
                    ),
                  );
                }),

                const SizedBox(height: 36),

                // ACTIVITY LOG
                Row(
                  children: [
                    const Icon(Icons.history_rounded,
                        size: 22, color: Colors.blueAccent),
                    const SizedBox(width: 6),
                    Text(
                      'Activity Log',
                      style: AppStyles.title.copyWith(
                        fontSize: isWeb
                            ? 20
                            : isTablet
                                ? 18
                                : 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final kpi = controller.kpiData.value;
                  if (kpi == null || kpi.activityLog.isEmpty) {
                    return const Text(
                      'Tidak ada aktivitas terbaru.',
                      style: TextStyle(color: Colors.black54),
                    );
                  }
                  return Column(
                    children: kpi.activityLog.map((log) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ActivityLogCard(
                          title: log.title,
                          description: log.description,
                          user: log.user,
                          date: log.date,
                          time: log.time,
                          category: log.category,
                          type: log.type,
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
