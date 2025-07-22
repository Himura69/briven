import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/admin/models/admin_device_model.dart';

class AdminDeviceCard extends StatelessWidget {
  final AdminDeviceModel device;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AdminDeviceCard({
    super.key,
    required this.device,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon perangkat
            Icon(Icons.devices, color: Colors.blueAccent, size: 36),
            const SizedBox(width: 16),
            // Info perangkat
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.brandName.isNotEmpty
                        ? '${device.brand} ${device.brandName}'
                        : device.brand,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Asset Code: ${device.assetCode}'),
                  Text('Serial: ${device.serialNumber}'),
                  Text('Kondisi: ${device.condition}'),
                  if (device.isAssigned && device.assignedTo != null)
                    Text('Dipinjam oleh: ${device.assignedTo}'),
                ],
              ),
            ),
            // Tombol aksi
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: onEdit,
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirmed = await Get.dialog<bool>(
                      AlertDialog(
                        title: const Text('Konfirmasi Hapus'),
                        content: Text(
                            'Apakah Anda yakin ingin menghapus perangkat ${device.assetCode}?'),
                        actions: [
                          TextButton(
                              onPressed: () => Get.back(result: false),
                              child: const Text('Batal')),
                          ElevatedButton(
                              onPressed: () => Get.back(result: true),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text('Hapus')),
                        ],
                      ),
                    );
                    if (confirmed == true && onDelete != null) {
                      onDelete!();
                    }
                  },
                  tooltip: 'Hapus',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
