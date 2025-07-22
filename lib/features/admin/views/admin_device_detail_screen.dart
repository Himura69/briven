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

    // Ambil data detail saat pertama kali load
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
        child: AdminNavBar(),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (errorMessage.value.isNotEmpty) {
          return Center(child: Text(errorMessage.value,
              style: const TextStyle(color: Colors.red)));
        }
        final device = deviceDetail.value;
        if (device == null) {
          return const Center(child: Text('Data perangkat tidak ditemukan.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${device.brand} ${device.brandName}',
                style: AppStyles.title.copyWith(fontSize: 24, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text('Asset Code: ${device.assetCode}'),
              Text('Serial Number: ${device.serialNumber}'),
              Text('Kondisi: ${device.condition}'),
              Text('Kategori: ${device.category}'),
              const SizedBox(height: 16),
              // Spesifikasi
              if (device.spec1 != null) Text('Spec1: ${device.spec1}'),
              if (device.spec2 != null) Text('Spec2: ${device.spec2}'),
              if (device.spec3 != null) Text('Spec3: ${device.spec3}'),
              if (device.spec4 != null) Text('Spec4: ${device.spec4}'),
              if (device.spec5 != null) Text('Spec5: ${device.spec5}'),
              const SizedBox(height: 24),

              // Assignment Sekarang
              if (device.isAssigned && device.assignedTo != null) ...[
                const Text(
                  'Sedang Dipinjam',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text('Dipinjam oleh: ${device.assignedTo}'),
                if (device.assignedDate != null)
                  Text('Tanggal Pinjam: ${device.assignedDate}'),
              ],

              const SizedBox(height: 24),
              // Riwayat Assignment
              const Text(
                'Riwayat Peminjaman',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              FutureBuilder<Map<String, dynamic>>(
                future: controller.apiService.getAdminDeviceDetail(device.deviceId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData ||
                      snapshot.data?['assignmentHistory'] == null) {
                    return const Text('Tidak ada riwayat peminjaman.');
                  }
                  final history = snapshot.data!['assignmentHistory'] as List<dynamic>;
                  if (history.isEmpty) {
                    return const Text('Tidak ada riwayat peminjaman.');
                  }
                  return Column(
                    children: history.map((item) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        child: ListTile(
                          title: Text('${item['userName']} (${item['userPn']})'),
                          subtitle: Text(
                              'Dipinjam: ${item['assignedDate']} - Dikembalikan: ${item['returnedDate'] ?? '-'}'),
                          trailing: Text(item['status']),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
