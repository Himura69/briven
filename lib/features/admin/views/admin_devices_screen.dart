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

    // Fetch data awal
    controller.fetchDevices();

    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 900;
    final isTablet = screenWidth >= 600 && screenWidth <= 900;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AdminNavBar(),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => DeviceFormScreen(), transition: Transition.fadeIn);
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Perangkat'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(isWeb
            ? 24.0
            : isTablet
                ? 16.0
                : 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Management',
              style: AppStyles.title.copyWith(
                fontSize: isWeb
                    ? 22
                    : isTablet
                        ? 20
                        : 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // Search & Filter Row
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
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: controller.selectedCondition.value.isEmpty
                      ? null
                      : controller.selectedCondition.value,
                  hint: const Text('Kondisi'),
                  items: const [
                    DropdownMenuItem(value: 'Baik', child: Text('Baik')),
                    DropdownMenuItem(value: 'Rusak', child: Text('Rusak')),
                    DropdownMenuItem(
                        value: 'Perlu Pengecekan',
                        child: Text('Perlu Pengecekan')),
                  ],
                  onChanged: (value) {
                    controller.selectedCondition.value = value ?? '';
                    controller.fetchDevices();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Device List
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
                  return const Center(child: Text('Tidak ada perangkat.'));
                }
                return ListView.builder(
                  itemCount: controller.devices.length,
                  itemBuilder: (context, index) {
                    final AdminDeviceModel device = controller.devices[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
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
            const SizedBox(height: 8),
            // Pagination
            Obx(() {
              if (controller.lastPage.value <= 1) return const SizedBox();
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: controller.currentPage.value > 1
                        ? () => controller.fetchDevices(
                            page: controller.currentPage.value - 1)
                        : null,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                      '${controller.currentPage.value} / ${controller.lastPage.value}'),
                  IconButton(
                    onPressed:
                        controller.currentPage.value < controller.lastPage.value
                            ? () => controller.fetchDevices(
                                page: controller.currentPage.value + 1)
                            : null,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
