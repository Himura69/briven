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

  // Warna berdasarkan kondisi perangkat
  Color _conditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'rusak':
        return Colors.redAccent;
      case 'perlu pengecekan':
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

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
            // Ikon perangkat
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

            // Detail perangkat
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
                    children: [
                      const Icon(Icons.qr_code, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Asset Code: ${device.assetCode}',
                          style: const TextStyle(color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Serial Number
                  Row(
                    children: [
                      const Icon(Icons.confirmation_number,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Serial: ${device.serialNumber}',
                          style: const TextStyle(color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Kondisi dengan warna sesuai status
                  Row(
                    children: [
                      Icon(Icons.circle,
                          size: 14, color: _conditionColor(device.condition)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Kondisi: ${device.condition}',
                          style: TextStyle(
                            color: _conditionColor(device.condition),
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Kategori sebagai chip interaktif
                  GestureDetector(
                    onTap: () {
                      if (onFilterByCategory != null &&
                          device.category.isNotEmpty) {
                        onFilterByCategory!(device.category);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.category_rounded,
                              size: 16, color: Colors.blueAccent),
                          const SizedBox(width: 4),
                          Text(
                            device.category.isNotEmpty
                                ? device.category
                                : 'Tidak ada kategori',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Status pinjam (User)
                  if (device.isAssigned && device.assignedTo != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person,
                              size: 16, color: Colors.orange),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Dipinjam: ${device.assignedTo} (User)',
                              style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Tombol Edit & Delete
            Column(
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
                      Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  size: 48, color: Colors.redAccent),
                              const SizedBox(height: 12),
                              const Text(
                                'Hapus Perangkat?',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Apakah Anda yakin ingin menghapus perangkat "${device.assetCode}"? Tindakan ini tidak bisa dibatalkan.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.grey),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                    ),
                                    onPressed: () => Get.back(result: false),
                                    child: const Text('Batal',
                                        style:
                                            TextStyle(color: Colors.black87)),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                    ),
                                    onPressed: () => Get.back(result: true),
                                    child: const Text('Hapus',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
