import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/nav_bar.dart';
import '../controllers/devices_list_controller.dart';
import '../models/device_model.dart';

class DevicesListScreen extends StatelessWidget {
  const DevicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DevicesListController controller = Get.put(DevicesListController());
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    final contentWidth = isWeb ? screenWidth * 0.6 : screenWidth * 0.9;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: NavBar(),
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isWeb ? 32.0 : 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.devices.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.errorMessage.value.isEmpty
                                      ? 'Tidak ada perangkat atau gagal memuat'
                                      : controller.errorMessage.value,
                                  style: AppStyles.body.copyWith(
                                    fontSize: isWeb ? 16 : 14,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                if (controller.errorMessage.value
                                    .contains('login'))
                                  CustomButton(
                                    text: 'Login',
                                    onPressed: () => Get.offAllNamed('/login'),
                                    width: isWeb ? 300 : double.infinity,
                                  )
                                else
                                  CustomButton(
                                    text: 'Coba Lagi',
                                    onPressed: controller.fetchDevices,
                                    width: isWeb ? 300 : double.infinity,
                                  ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.devices.length,
                            itemBuilder: (context, index) {
                              final device = controller.devices[index];
                              return _buildDeviceCard(device, isWeb);
                            },
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard(DeviceModel device, bool isWeb) {
    print(
        'Merender perangkat: ${device.toJson()}'); // Log perangkat yang dirender
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          '${device.brand ?? 'Perangkat Tidak Dikenal'} (${device.serialNumber ?? 'Tanpa Serial'})',
          style: AppStyles.body.copyWith(
            fontSize: isWeb ? 16 : 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Kategori: ${device.categoryName ?? 'Tipe Tidak Dikenal'}',
          style: AppStyles.body.copyWith(
            fontSize: isWeb ? 14 : 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: isWeb ? 20 : 16,
          color: AppColors.primary,
        ),
        onTap: device.deviceId != null
            ? () {
                Get.toNamed('/device_detail',
                    arguments: {'deviceId': device.deviceId});
              }
            : null,
      ),
    );
  }
}
