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
    final colors = [Colors.green, Colors.red, Colors.orange];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: List.generate(data.length, (i) {
                  final percentage =
                      total == 0 ? 0 : (data[i].count / total * 100);
                  return PieChartSectionData(
                    color: colors[i % colors.length],
                    value: data[i].count.toDouble(),
                    title: '${percentage.toStringAsFixed(1)}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // LEGEND
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
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
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${data[i].condition} (${data[i].count})',
                    style: const TextStyle(color: Colors.black87, fontSize: 13),
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
