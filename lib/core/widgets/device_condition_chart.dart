import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../features/admin/models/chart_data_model.dart';

class DeviceConditionChart extends StatelessWidget {
  final List<DeviceConditionData> data;

  const DeviceConditionChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Text(
        'Tidak ada data kondisi perangkat',
        style: TextStyle(color: Colors.black54),
      );
    }

    final total = data.fold<int>(0, (sum, item) => sum + item.count);

    // Palet warna konsisten & modern
    final colors = [
      Colors.greenAccent.shade400, // Baik
      Colors.redAccent.shade400, // Rusak
      Colors.orangeAccent.shade400 // Perlu Pengecekan
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                borderData: FlBorderData(show: false),
                sections: List.generate(data.length, (i) {
                  final percentage =
                      total == 0 ? 0 : (data[i].count / total * 100);
                  return PieChartSectionData(
                    color: colors[i % colors.length],
                    value: data[i].count.toDouble(),
                    title: '${percentage.toStringAsFixed(1)}%',
                    radius: 65,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // LEGEND
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 10,
            children: List.generate(data.length, (i) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colors[i % colors.length].withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${data[i].condition} (${data[i].count})',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
