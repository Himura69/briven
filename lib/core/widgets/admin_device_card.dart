import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/admin/models/admin_device_model.dart';

class AdminDeviceCard extends StatelessWidget {
  final AdminDeviceModel device;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<String>? onFilterByCategory;

  const AdminDeviceCard({
    super.key,
    required this.device,
    this.onEdit,
    this.onDelete,
    this.onFilterByCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon perangkat di kiri
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.devices_rounded,
                  color: Colors.blueAccent, size: 36),
            ),
            const SizedBox(width: 16),

            // Info perangkat di tengah
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Brand & Model
                  Text(
                    device.brandName.isNotEmpty
                        ? '${device.brand} ${device.brandName}'
                        : device.brand,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 6),

                  // Asset Code
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.qr_code, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Asset Code: ${device.assetCode}',
                          style: const TextStyle(color: Colors.black54),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Serial Number
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.confirmation_number,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Serial: ${device.serialNumber}',
                          style: const TextStyle(color: Colors.black54),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Kondisi
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Kondisi: ${device.condition}',
                          style: const TextStyle(color: Colors.black54),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Kategori sebagai Chip (klik untuk filter)
                  GestureDetector(
                    onTap: () {
                      if (onFilterByCategory != null &&
                          device.category.isNotEmpty) {
                        onFilterByCategory!(device.category);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.category_rounded,
                              size: 16, color: Colors.blueAccent),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              device.category.isNotEmpty
                                  ? device.category
                                  : 'Tidak ada kategori',
                              style: TextStyle(
                                fontSize: 13,
                                color: device.category.isNotEmpty
                                    ? Colors.blueAccent
                                    : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Status assignment
                  if (device.isAssigned && device.assignedTo != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.person,
                            size: 16, color: Colors.orange),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Dipinjam oleh: ${device.assignedTo}',
                            style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w500),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Tombol aksi (Edit & Delete)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                  onPressed: onEdit,
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: () async {
                    final confirmed = await Get.dialog<bool>(
                      AlertDialog(
                        title: const Text('Konfirmasi Hapus'),
                        content: Text(
                            'Apakah Anda yakin ingin menghapus perangkat ${device.assetCode}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () => Get.back(result: true),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text('Hapus'),
                          ),
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
