import 'package:flutter/material.dart';
import '../../features/admin/models/admin_device_model.dart';

class AdminDeviceCard extends StatelessWidget {
  final AdminDeviceModel device;

  const AdminDeviceCard({super.key, required this.device});

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'baik':
        return Colors.green;
      case 'rusak':
        return Colors.red;
      case 'perlu pengecekan':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Device Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device.brand,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'SN: ${device.serialNumber}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),

          // Condition Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getConditionColor(device.condition).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getConditionColor(device.condition),
                width: 1,
              ),
            ),
            child: Text(
              device.condition,
              style: TextStyle(
                color: _getConditionColor(device.condition),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
