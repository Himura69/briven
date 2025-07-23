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
        style: TextStyle(color: Colors.black54),
      );
    }

    final maxY =
        (data.map((e) => e.count).reduce((a, b) => a > b ? a : b)).toDouble();

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
      child: SizedBox(
        height: 280,
        child: BarChart(
          BarChartData(
            maxY: maxY + 5,
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 5,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: _leftTitleWidgets,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < data.length) {
                      return Transform.rotate(
                        angle: -0.5, // Rotasi 45° agar tidak bertabrakan
                        child: Text(
                          data[index].branchName,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                    width: 20,
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.shade400,
                        Colors.lightBlue.shade200
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxY + 5,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ],
              );
            }),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipPadding: const EdgeInsets.all(8),
                tooltipRoundedRadius: 8,
                tooltipMargin: 10,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${data[groupIndex].branchName}\n'
                    '${data[groupIndex].count} perangkat',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: Offset(1, 1),
                        )
                      ],
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

  static Widget _leftTitleWidgets(double value, TitleMeta meta) {
    return Text(
      value.toInt().toString(),
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.left,
    );
  }
}
