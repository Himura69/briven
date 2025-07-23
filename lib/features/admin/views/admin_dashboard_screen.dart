import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_styles.dart';
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
    final isWeb = screenWidth > 1000;
    final isTablet = screenWidth >= 600 && screenWidth <= 1000;
    final crossAxisCount = isWeb
        ? 4
        : isTablet
            ? 2
            : 2;

    final controller = Get.put(AdminDashboardController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isWeb
            ? 32.0
            : isTablet
                ? 24.0
                : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI GRID
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
              final kpiItems = [
                KpiCard(
                    title: 'Total Devices',
                    value: kpi.totalDevices.toString(),
                    color: Colors.blueAccent),
                KpiCard(
                    title: 'In Use',
                    value: kpi.inUse.toString(),
                    color: Colors.green),
                KpiCard(
                    title: 'Available',
                    value: kpi.available.toString(),
                    color: Colors.orange),
                KpiCard(
                    title: 'Damaged',
                    value: kpi.damaged.toString(),
                    color: Colors.redAccent),
              ];

              return GridView.builder(
                itemCount: kpiItems.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: isWeb ? 1.5 : 1.2,
                ),
                itemBuilder: (_, i) => kpiItems[i],
              );
            }),

            const SizedBox(height: 32),

            // CHARTS SECTION (Pie + Bar)
            Obx(() {
              final chart = controller.chartData.value;
              if (chart == null) {
                return const Center(
                    child: Text('Tidak ada data untuk ditampilkan.'));
              }

              if (isWeb || isTablet) {
                // Jika layar lebar, dua chart disusun horizontal
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildChartCard(
                        title: 'Kondisi Perangkat',
                        icon: Icons.pie_chart_rounded,
                        child: chart.deviceConditions.isEmpty
                            ? const Text('Tidak ada data kondisi perangkat.',
                                style: TextStyle(color: Colors.black54))
                            : DeviceConditionChart(
                                data: chart.deviceConditions,
                              ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildChartCard(
                        title: 'Distribusi Perangkat per Cabang',
                        icon: Icons.bar_chart_rounded,
                        child: chart.devicesPerBranch.isEmpty
                            ? const Text('Tidak ada data distribusi cabang.',
                                style: TextStyle(color: Colors.black54))
                            : BranchDistributionChart(
                                data: chart.devicesPerBranch,
                              ),
                      ),
                    ),
                  ],
                );
              } else {
                // Jika layar kecil, ditumpuk vertikal
                return Column(
                  children: [
                    _buildChartCard(
                      title: 'Kondisi Perangkat',
                      icon: Icons.pie_chart_rounded,
                      child: chart.deviceConditions.isEmpty
                          ? const Text('Tidak ada data kondisi perangkat.',
                              style: TextStyle(color: Colors.black54))
                          : DeviceConditionChart(
                              data: chart.deviceConditions,
                            ),
                    ),
                    const SizedBox(height: 24),
                    _buildChartCard(
                      title: 'Distribusi Perangkat per Cabang',
                      icon: Icons.bar_chart_rounded,
                      child: chart.devicesPerBranch.isEmpty
                          ? const Text('Tidak ada data distribusi cabang.',
                              style: TextStyle(color: Colors.black54))
                          : BranchDistributionChart(
                              data: chart.devicesPerBranch,
                            ),
                    ),
                  ],
                );
              }
            }),

            const SizedBox(height: 32),

            // ACTIVITY LOG
            Obx(() {
              final kpi = controller.kpiData.value;
              if (kpi == null || kpi.activityLog.isEmpty) {
                return const Text('Tidak ada aktivitas terbaru.',
                    style: TextStyle(color: Colors.black54));
              }
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.history_rounded,
                              size: 22, color: Colors.blueAccent),
                          SizedBox(width: 6),
                          Text('Activity Log',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.black87)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...kpi.activityLog.map((log) {
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
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 22, color: Colors.blueAccent),
                const SizedBox(width: 6),
                Text(title,
                    style: AppStyles.title.copyWith(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
