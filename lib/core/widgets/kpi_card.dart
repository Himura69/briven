import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  IconData _getIconForTitle() {
    switch (title.toLowerCase()) {
      case 'total devices':
        return Icons.devices_other_rounded;
      case 'in use':
        return Icons.playlist_add_check_rounded;
      case 'available':
        return Icons.check_circle_outline_rounded;
      case 'damaged':
        return Icons.error_outline_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.05),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon di atas
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(
              _getIconForTitle(),
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(height: 12),
          // Judul KPI
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 6),
          // Nilai KPI
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
