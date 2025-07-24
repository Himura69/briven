import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_styles.dart';
import '../controllers/admin_devices_controller.dart';
import '../models/admin_device_model.dart';

class AdminDeviceDetailScreen extends StatelessWidget {
  final int deviceId;
  AdminDeviceDetailScreen({super.key, required this.deviceId});

  final AdminDevicesController controller = Get.find<AdminDevicesController>();

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
    final isLoading = false.obs;
    final deviceDetail = Rxn<AdminDeviceModel>();
    final errorMessage = ''.obs;

    Future<void> loadDetail() async {
      try {
        isLoading.value = true;
        final data = await controller.fetchDeviceDetail(deviceId);
        deviceDetail.value = data;
      } catch (e) {
        errorMessage.value = 'Gagal memuat detail perangkat: $e';
      } finally {
        isLoading.value = false;
      }
    }

    loadDetail();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Detail Perangkat",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF4F6F8),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(errorMessage.value,
                style: const TextStyle(color: Colors.red)),
          );
        }
        final device = deviceDetail.value;
        if (device == null) {
          return const Center(child: Text('Data perangkat tidak ditemukan.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Info utama perangkat
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.devices_rounded,
                              color: Colors.blueAccent, size: 40),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${device.brand} ${device.brandName}',
                              style: AppStyles.title.copyWith(
                                  fontSize: 22, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Detail utama
                      _infoRow(Icons.qr_code, 'Asset Code', device.assetCode),
                      _infoRow(Icons.confirmation_number, 'Serial',
                          device.serialNumber),

                      // Kondisi (warna dinamis)
                      Row(
                        children: [
                          Icon(Icons.circle,
                              size: 14,
                              color: _conditionColor(device.condition)),
                          const SizedBox(width: 8),
                          Text(
                            'Kondisi: ${device.condition}',
                            style: TextStyle(
                              color: _conditionColor(device.condition),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Kategori (chip style)
                      if (device.category.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.category_rounded,
                                  size: 16, color: Colors.blueAccent),
                              const SizedBox(width: 6),
                              Text(
                                device.category,
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (device.devDate != null) ...[
                        const SizedBox(height: 12),
                        _infoRow(Icons.calendar_today, 'Tanggal Peminjaman',
                            device.devDate!),
                      ],

                      const SizedBox(height: 12),
                      // Spesifikasi
                      ...[
                        if (device.spec1 != null)
                          _infoRow(
                              Icons.settings, 'Spesifikasi 1', device.spec1!),
                        if (device.spec2 != null)
                          _infoRow(
                              Icons.settings, 'Spesifikasi 2', device.spec2!),
                        if (device.spec3 != null)
                          _infoRow(
                              Icons.settings, 'Spesifikasi 3', device.spec3!),
                        if (device.spec4 != null)
                          _infoRow(
                              Icons.settings, 'Spesifikasi 4', device.spec4!),
                        if (device.spec5 != null)
                          _infoRow(
                              Icons.settings, 'Spesifikasi 5', device.spec5!),
                      ],
                    ],
                  ),
                ),
              ),

              // Status Peminjaman
              if (device.isAssigned && device.assignedTo != null)
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.person,
                              color: Colors.orange, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sedang Dipinjam',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Dipinjam oleh: ${device.assignedTo}',
                                style: const TextStyle(color: Colors.black87),
                              ),
                              if (device.assignedDate != null)
                                Text('Tanggal Pinjam: ${device.assignedDate}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Riwayat Peminjaman
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                margin: const EdgeInsets.only(top: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.history,
                              color: Colors.blueAccent, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Riwayat Peminjaman',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Jika tidak ada riwayat
                      if (device.assignmentHistory.isEmpty)
                        const Center(
                          child: Text(
                            'Tidak ada riwayat peminjaman.',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 14),
                          ),
                        )
                      else
                        Column(
                          children: device.assignmentHistory.map((item) {
                            final isActive =
                                item.status.toLowerCase() == 'active';
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: isActive
                                      ? Colors.green
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: Icon(
                                  Icons.person,
                                  color: isActive ? Colors.green : Colors.grey,
                                ),
                                title: Text(
                                  '${item.userName} (${item.userPn})',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  'Pinjam: ${item.assignedDate}\nKembali: ${item.returnedDate ?? '-'}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.status,
                                    style: TextStyle(
                                      color:
                                          isActive ? Colors.green : Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
