import 'package:briven/features/admin/views/admin_device_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/admin_nav_bar.dart';
import '../controllers/admin_devices_controller.dart';
import '../models/admin_device_model.dart';
import '../../../core/widgets/admin_device_card.dart';
import 'device_form_screen.dart';

class AdminDevicesScreen extends StatelessWidget {
  const AdminDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminDevicesController controller = Get.put(AdminDevicesController());
    controller.fetchDevices();

    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 900;
    final isTablet = screenWidth >= 600 && screenWidth <= 900;

    // Menentukan radius yang akan digunakan
    final double buttonRadius = 10.0; // Contoh radius 10

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AdminNavBar(),
      ),
      backgroundColor: const Color(0xFFF8F9FB),
      // FloatingActionButton dihapus
      body: Padding(
        padding: EdgeInsets.all(isWeb
            ? 24.0
            : isTablet
                ? 20.0
                : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Baris untuk Search Field dan Tombol yang sejajar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      controller.searchQuery.value = value;
                      controller.fetchDevices();
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari perangkat...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.filter_list,
                                color: Colors.blueAccent),
                            onSelected: (value) {
                              controller.selectedCondition.value = value;
                              controller.fetchDevices();
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(value: 'Baik', child: Text('Baik')),
                              PopupMenuItem(
                                  value: 'Rusak', child: Text('Rusak')),
                              PopupMenuItem(
                                  value: 'Perlu Pengecekan',
                                  child: Text('Perlu Pengecekan')),
                            ],
                          ),
                          Obx(() {
                            if (controller.selectedCondition.value.isEmpty) {
                              return const SizedBox();
                            }
                            return IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              color: Colors.redAccent,
                              tooltip: 'Hapus Filter',
                              onPressed: () {
                                controller.selectedCondition.value = '';
                                controller.fetchDevices();
                              },
                            );
                          }),
                        ],
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        // Menggunakan radius yang disamakan
                        borderRadius: BorderRadius.circular(buttonRadius),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // Menggunakan radius yang disamakan
                        borderRadius: BorderRadius.circular(buttonRadius),
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 1.2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => DeviceFormScreen(),
                        transition: Transition.fadeIn);
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Tambah Perangkat',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      // Menggunakan radius yang disamakan
                      borderRadius: BorderRadius.circular(buttonRadius),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Pagination
            Obx(() {
              if (controller.lastPage.value <= 1) return const SizedBox();
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  // Menggunakan radius yang disamakan
                  borderRadius: BorderRadius.circular(buttonRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: controller.currentPage.value > 1
                          ? () => controller.fetchDevices(
                              page: controller.currentPage.value - 1)
                          : null,
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.blueAccent),
                    ),
                    Text(
                      '${controller.currentPage.value} / ${controller.lastPage.value}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    IconButton(
                      onPressed: controller.currentPage.value <
                              controller.lastPage.value
                          ? () => controller.fetchDevices(
                              page: controller.currentPage.value + 1)
                          : null,
                      icon: const Icon(Icons.chevron_right,
                          color: Colors.blueAccent),
                    ),
                  ],
                ),
              );
            }),

            // List perangkat
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red)),
                  );
                }
                if (controller.devices.isEmpty) {
                  return const Center(
                      child: Text(
                    'Tidak ada perangkat.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ));
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.devices.length,
                  itemBuilder: (context, index) {
                    final AdminDeviceModel device = controller.devices[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                              () => AdminDeviceDetailScreen(
                                  deviceId: device.deviceId),
                              transition: Transition.rightToLeft);
                        },
                        child: AdminDeviceCard(
                          device: device,
                          onEdit: () {
                            Get.to(() => DeviceFormScreen(device: device),
                                transition: Transition.fadeIn);
                          },
                          onDelete: () async {
                            await controller.deleteDevice(device.deviceId);
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
