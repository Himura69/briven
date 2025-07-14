import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/device_detail_controller.dart';
import '../models/device_detail_model.dart';

class DeviceDetailScreen extends StatefulWidget {
  const DeviceDetailScreen({super.key});

  @override
  _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  bool _isLocaleInitialized = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi data lokal untuk 'id_ID'
    initializeDateFormatting('id_ID', null).then((_) {
      setState(() {
        _isLocaleInitialized = true;
      });
    });
  }

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
                            : _isLocaleInitialized
                                ? _buildDeviceDetail(
                                    controller.device.value!, isWeb)
                                : const Center(
                                    child: CircularProgressIndicator()),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceDetail(DeviceDetailModel device, bool isWeb) {
    print('Merender detail perangkat: ${device.toJson()}');
    // Format tanggal untuk assignedDate
    String? formattedDate;
    if (device.assignedDate != null) {
      try {
        final date = DateTime.parse(device.assignedDate!);
        final dateFormat = DateFormat('d MMMM yyyy', 'id_ID');
        formattedDate = dateFormat.format(date);
      } catch (e) {
        print('Error parsing assignedDate: $e');
        formattedDate = 'Format Tanggal Tidak Valid';
      }
    }

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
            _buildDetailRow('ID Perangkat', device.deviceId?.toString(), isWeb),
            _buildDetailRow('Merek', device.brand, isWeb),
            _buildDetailRow('Nomor Seri', device.serialNumber, isWeb),
            _buildDetailRow('Kode Aset', device.assetCode, isWeb),
            _buildDetailRow('Tanggal Penugasan', formattedDate, isWeb),
            _buildDetailRow('Spesifikasi 1', device.spec1, isWeb),
            _buildDetailRow('Spesifikasi 2', device.spec2, isWeb),
            _buildDetailRow('Spesifikasi 3', device.spec3, isWeb),
            if (device.spec4 != null)
              _buildDetailRow('Spesifikasi 4', device.spec4, isWeb),
            if (device.spec5 != null)
              _buildDetailRow('Spesifikasi 5', device.spec5, isWeb),
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

  Widget _buildDetailRow(String label, String? value, bool isWeb,
      {Color? textColor}) {
    print('Merender baris detail: $label = $value');
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
              value ?? 'Tidak Tersedia',
              style: AppStyles.body.copyWith(
                fontSize: isWeb ? 16 : 14,
                color: value == null
                    ? Colors.red
                    : (textColor ?? Colors.grey[600]),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
