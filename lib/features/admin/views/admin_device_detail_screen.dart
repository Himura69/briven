import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/admin_nav_bar.dart';
import '../controllers/admin_devices_controller.dart';
import '../models/admin_device_model.dart';

class AdminDeviceDetailScreen extends StatelessWidget {
  final int deviceId;
  AdminDeviceDetailScreen({super.key, required this.deviceId});

  final AdminDevicesController controller = Get.find<AdminDevicesController>();

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
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
      ),
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (errorMessage.value.isNotEmpty) {
          return Center(
              child: Text(errorMessage.value,
                  style: const TextStyle(color: Colors.red)));
        }
        final device = deviceDetail.value;
        if (device == null) {
          return const Center(child: Text('Data perangkat tidak ditemukan.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${device.brand} ${device.brandName}',
                        style: AppStyles.title
                            .copyWith(fontSize: 22, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Text('Asset Code: ${device.assetCode}'),
                      Text('Serial Number: ${device.serialNumber}'),
                      Text('Kondisi: ${device.condition}'),
                      Text(
                        'Kategori: ${device.category.isNotEmpty ? device.category : '-'}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      if (device.devDate != null)
                        Text('Tanggal Pembelian: ${device.devDate}'),
                      const SizedBox(height: 12),
                      // Spesifikasi Tambahan
                      ...[
                        if (device.spec1 != null)
                          Text('Spesifikasi 1: ${device.spec1}'),
                        if (device.spec2 != null)
                          Text('Spesifikasi 2: ${device.spec2}'),
                        if (device.spec3 != null)
                          Text('Spesifikasi 3: ${device.spec3}'),
                        if (device.spec4 != null)
                          Text('Spesifikasi 4: ${device.spec4}'),
                        if (device.spec5 != null)
                          Text('Spesifikasi 5: ${device.spec5}'),
                      ],
                    ],
                  ),
                ),
              ),

              // Status peminjaman saat ini
              if (device.isAssigned && device.assignedTo != null)
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sedang Dipinjam',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text('Dipinjam oleh: ${device.assignedTo}'),
                        if (device.assignedDate != null)
                          Text('Tanggal Pinjam: ${device.assignedDate}'),
                      ],
                    ),
                  ),
                ),

              // Riwayat Peminjaman
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Riwayat Peminjaman',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      if (device.assignmentHistory.isEmpty)
                        const Text('Tidak ada riwayat peminjaman.')
                      else
                        ...device.assignmentHistory.map((item) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 1,
                            child: ListTile(
                              title: Text('${item.userName} (${item.userPn})'),
                              subtitle: Text(
                                  'Dipinjam: ${item.assignedDate} - Dikembalikan: ${item.returnedDate ?? '-'}'),
                              trailing: Text(item.status),
                            ),
                          );
                        }).toList(),
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
}
