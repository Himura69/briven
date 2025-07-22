import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../admin/controllers/admin_devices_controller.dart';
import '../../admin/models/admin_device_model.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/admin_nav_bar.dart';

class DeviceFormScreen extends StatelessWidget {
  final AdminDeviceModel? device;
  final AdminDevicesController controller = Get.find<AdminDevicesController>();

  DeviceFormScreen({super.key, this.device});

  @override
  Widget build(BuildContext context) {
    final isEditing = device != null;

    // Text controllers
    final brandController = TextEditingController(text: device?.brand ?? '');
    final brandNameController = TextEditingController(text: device?.brandName ?? '');
    final serialController = TextEditingController(text: device?.serialNumber ?? '');
    final assetCodeController = TextEditingController(text: device?.assetCode ?? '');
    final briboxIdController = TextEditingController(text: ''); // sementara, bisa pakai dropdown
    final spec1Controller = TextEditingController(text: device?.spec1 ?? '');
    final spec2Controller = TextEditingController(text: device?.spec2 ?? '');
    final spec3Controller = TextEditingController(text: device?.spec3 ?? '');
    final spec4Controller = TextEditingController(text: device?.spec4 ?? '');
    final spec5Controller = TextEditingController(text: device?.spec5 ?? '');
    final devDateController = TextEditingController(); // format ISO date, bisa pakai date picker

    final condition = RxString(device?.condition ?? 'Baik');

    void saveDevice() async {
      final data = {
        'brand': brandController.text,
        'brandName': brandNameController.text,
        'serialNumber': serialController.text,
        'assetCode': assetCodeController.text,
        'briboxId': briboxIdController.text,
        'condition': condition.value,
        'spec1': spec1Controller.text.isNotEmpty ? spec1Controller.text : null,
        'spec2': spec2Controller.text.isNotEmpty ? spec2Controller.text : null,
        'spec3': spec3Controller.text.isNotEmpty ? spec3Controller.text : null,
        'spec4': spec4Controller.text.isNotEmpty ? spec4Controller.text : null,
        'spec5': spec5Controller.text.isNotEmpty ? spec5Controller.text : null,
        'devDate': devDateController.text.isNotEmpty ? devDateController.text : null,
      };

      if (isEditing) {
        await controller.updateDevice(device!.deviceId, data);
      } else {
        await controller.createDevice(data);
      }

      Get.back(); // Kembali ke list
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AdminNavBar(),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Edit Perangkat' : 'Tambah Perangkat',
              style: AppStyles.title.copyWith(fontSize: 22, color: Colors.black87),
            ),
            const SizedBox(height: 24),

            // Brand
            TextField(
              controller: brandController,
              decoration: _inputDecoration('Brand'),
            ),
            const SizedBox(height: 16),

            // Brand Name
            TextField(
              controller: brandNameController,
              decoration: _inputDecoration('Brand Name'),
            ),
            const SizedBox(height: 16),

            // Serial Number
            TextField(
              controller: serialController,
              decoration: _inputDecoration('Serial Number'),
            ),
            const SizedBox(height: 16),

            // Asset Code
            TextField(
              controller: assetCodeController,
              decoration: _inputDecoration('Asset Code'),
            ),
            const SizedBox(height: 16),

            // Bribox ID
            TextField(
              controller: briboxIdController,
              decoration: _inputDecoration('Bribox ID'),
            ),
            const SizedBox(height: 16),

            // Condition Dropdown
            Obx(() => DropdownButtonFormField<String>(
                  value: condition.value,
                  items: const [
                    DropdownMenuItem(value: 'Baik', child: Text('Baik')),
                    DropdownMenuItem(value: 'Rusak', child: Text('Rusak')),
                    DropdownMenuItem(
                        value: 'Perlu Pengecekan', child: Text('Perlu Pengecekan')),
                  ],
                  onChanged: (value) => condition.value = value ?? 'Baik',
                  decoration: _inputDecoration('Kondisi'),
                )),
            const SizedBox(height: 16),

            // Spec fields
            TextField(
              controller: spec1Controller,
              decoration: _inputDecoration('Spesifikasi 1'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: spec2Controller,
              decoration: _inputDecoration('Spesifikasi 2'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: spec3Controller,
              decoration: _inputDecoration('Spesifikasi 3'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: spec4Controller,
              decoration: _inputDecoration('Spesifikasi 4'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: spec5Controller,
              decoration: _inputDecoration('Spesifikasi 5'),
            ),
            const SizedBox(height: 16),

            // Dev Date
            TextField(
              controller: devDateController,
              decoration: _inputDecoration('Tanggal Pengadaan (YYYY-MM-DD)'),
            ),
            const SizedBox(height: 24),

            // Save Button
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
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
