import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../../../../core/widgets/admin_nav_bar.dart';
import '../../admin/models/admin_device_model.dart';
import '../../../../../services/api_service.dart';
import '../controllers/admin_devices_controller.dart';

class DeviceFormScreen extends StatelessWidget {
  final AdminDeviceModel? device =
      Get.arguments as AdminDeviceModel?; // null jika tambah baru
  final ApiService apiService = Get.find<ApiService>();

  DeviceFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isEditing = device != null;

    final brandController =
        TextEditingController(text: isEditing ? device!.brand : '');
    final serialController =
        TextEditingController(text: isEditing ? device!.serialNumber : '');
    final condition = RxString(isEditing ? device!.condition : 'Baik');

    Future<void> saveDevice() async {
      try {
        if (isEditing) {
          await apiService.updateDevice(
            deviceId: device!.deviceId,
            brand: brandController.text,
            serialNumber: serialController.text,
            condition: condition.value,
          );
          Get.snackbar('Sukses', 'Perangkat berhasil diperbarui');
        } else {
          await apiService.createDevice(
            brand: brandController.text,
            serialNumber: serialController.text,
            condition: condition.value,
          );
          Get.snackbar('Sukses', 'Perangkat berhasil ditambahkan');
        }

        // Refresh list di AdminDevicesController
        final devicesController = Get.find<AdminDevicesController>();
        devicesController.fetchDevices();

        Get.back(); // kembali ke list
      } catch (e) {
        Get.snackbar('Error', 'Gagal menyimpan perangkat: $e');
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AdminNavBar(),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Perangkat' : 'Tambah Perangkat',
                style: AppStyles.title.copyWith(
                  fontSize: 22,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: brandController,
                decoration: InputDecoration(
                  labelText: 'Brand',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: serialController,
                decoration: InputDecoration(
                  labelText: 'Serial Number',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<String>(
                    value: condition.value,
                    items: const [
                      DropdownMenuItem(value: 'Baik', child: Text('Baik')),
                      DropdownMenuItem(value: 'Rusak', child: Text('Rusak')),
                      DropdownMenuItem(
                          value: 'Perlu Pengecekan',
                          child: Text('Perlu Pengecekan')),
                    ],
                    onChanged: (value) {
                      condition.value = value ?? 'Baik';
                    },
                    decoration: InputDecoration(
                      labelText: 'Kondisi',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveDevice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    isEditing ? 'Simpan Perubahan' : 'Tambah Perangkat',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
