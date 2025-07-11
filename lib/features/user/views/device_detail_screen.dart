import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/device_detail_controller.dart';
import '../models/device_model.dart';

class DeviceDetailScreen extends StatelessWidget {
  const DeviceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DeviceDetailController controller = Get.put(DeviceDetailController());
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    final contentWidth = isWeb ? screenWidth * 0.6 : screenWidth * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Perangkat'),
        backgroundColor: AppColors.primary,
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
                    : controller.errorMessage.value.isNotEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.errorMessage.value,
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
                                    onPressed: () =>
                                        controller.fetchDeviceDetail(
                                            Get.arguments['deviceId']),
                                    width: isWeb ? 300 : double.infinity,
                                  ),
                              ],
                            ),
                          )
                        : controller.device.value == null
                            ? Center(
                                child: Text(
                                  'Data perangkat tidak tersedia',
                                  style: AppStyles.body.copyWith(
                                    fontSize: isWeb ? 16 : 14,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            : _buildDeviceDetail(
                                controller.device.value!, isWeb),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceDetail(DeviceModel device, bool isWeb) {
    print('Merender detail perangkat: ${device.toJson()}');
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Perangkat',
              style: AppStyles.body.copyWith(
                fontSize: isWeb ? 20 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('ID Perangkat',
                device.deviceId?.toString() ?? 'Tidak Diketahui', isWeb),
            _buildDetailRow('Merek', device.brand ?? 'Tidak Diketahui', isWeb),
            _buildDetailRow(
                'Nomor Seri', device.serialNumber ?? 'Tidak Diketahui', isWeb),
            _buildDetailRow(
              'Kategori',
              device.categoryName ??
                  'Kategori tidak tersedia, hubungi dukungan',
              isWeb,
              textColor: device.categoryName == null ||
                      device.categoryName == 'Unknown Category'
                  ? Colors.red
                  : Colors.grey[600],
            ),
            _buildDetailRow('ID Penugasan',
                device.assignmentId?.toString() ?? 'Tidak Diketahui', isWeb),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Kembali',
              onPressed: () => Get.back(),
              width: isWeb ? 300 : double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isWeb,
      {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.body.copyWith(
              fontSize: isWeb ? 16 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AppStyles.body.copyWith(
                fontSize: isWeb ? 16 : 14,
                color: textColor ?? Colors.grey[600],
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
