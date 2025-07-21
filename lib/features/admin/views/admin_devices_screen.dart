import 'package:briven/features/admin/controllers/admin_devices_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../../../../core/widgets/admin_nav_bar.dart';
import '../../../../../core/widgets/admin_device_card.dart';
import '../../admin/controllers/admin_dashboard_controller.dart';
import '../../../../../core/constants/app_routes.dart';

class AdminDevicesScreen extends StatelessWidget {
  const AdminDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminDevicesController());
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 900;
    final isTablet = screenWidth >= 600 && screenWidth <= 900;
    final contentWidth = isWeb ? screenWidth * 0.7 : screenWidth * 0.95;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AdminNavBar(),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isWeb
              ? 32.0
              : isTablet
                  ? 24.0
                  : 16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Text(
                  'Manajemen Perangkat',
                  style: AppStyles.title.copyWith(
                    fontSize: isWeb
                        ? 24
                        : isTablet
                            ? 22
                            : 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),

                // SEARCH & FILTER
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari perangkat...',
                          filled: true,
                          fillColor: Colors.grey[100],
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          controller.search(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: controller.conditionFilter.value.isEmpty
                          ? null
                          : controller.conditionFilter.value,
                      hint: const Text('Filter Kondisi'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Baik',
                          child: Text('Baik'),
                        ),
                        DropdownMenuItem(
                          value: 'Rusak',
                          child: Text('Rusak'),
                        ),
                        DropdownMenuItem(
                          value: 'Perlu Pengecekan',
                          child: Text('Perlu Pengecekan'),
                        ),
                      ],
                      onChanged: (value) {
                        controller.filterCondition(value ?? '');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // DEVICE LIST
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.errorMessage.isNotEmpty) {
                    return Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.redAccent),
                    );
                  }
                  if (controller.devices.isEmpty) {
                    return const Text(
                      'Tidak ada perangkat ditemukan.',
                      style: TextStyle(color: Colors.black54),
                    );
                  }

                  return Column(
                    children: controller.devices.map((device) {
                      return GestureDetector(
                        onTap: () {
                          // Edit perangkat
                          Get.toNamed(
                            AppRoutes.adminDeviceForm,
                            arguments: device,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AdminDeviceCard(device: device),
                        ),
                      );
                    }).toList(),
                  );
                }),

                const SizedBox(height: 24),

                // PAGINATION
                Obx(() {
                  if (controller.lastPage.value <= 1) {
                    return const SizedBox.shrink();
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: controller.currentPage.value > 1
                            ? controller.prevPage
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        child: const Text('Prev'),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${controller.currentPage.value} / ${controller.lastPage.value}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: controller.currentPage.value <
                                controller.lastPage.value
                            ? controller.nextPage
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        child: const Text('Next'),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),

      // FAB Tambah Perangkat
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(AppRoutes.adminDeviceForm); // route tambah perangkat
        },
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Perangkat',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
