import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../features/admin/models/chart_data_model.dart';

class BranchDistributionChart extends StatelessWidget {
  final List<DevicesPerBranchData> data;

  const BranchDistributionChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Text(
        'Tidak ada data distribusi cabang',
        style: TextStyle(color: Colors.white70),
      );
    }

    final maxY =
        (data.map((e) => e.count).reduce((a, b) => a > b ? a : b)).toDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: SizedBox(
        height: 250,
        child: BarChart(
          BarChartData(
            maxY: maxY + 5,
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 28),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < data.length) {
                      return Text(
                        data[index].branchName,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            barGroups: List.generate(data.length, (i) {
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: data[i].count.toDouble(),
                    color: Colors.blueAccent,
                    width: 22,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
                showingTooltipIndicators: [0],
              );
            }),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipPadding: const EdgeInsets.all(6),
                tooltipRoundedRadius: 6,
                tooltipMargin: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${data[groupIndex].branchName}\n${data[groupIndex].count} perangkat',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
