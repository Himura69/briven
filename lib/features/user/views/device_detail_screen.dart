import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/nav_bar.dart';
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
    final isWeb = screenWidth > 900;
    final isTablet = screenWidth >= 600 && screenWidth <= 900;
    final contentWidth = isWeb ? screenWidth * 0.6 : screenWidth * 0.9;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: NavBar(),
      ),
      backgroundColor: const Color.fromARGB(255, 220, 217, 217),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              AppColors.gradientEnd.withOpacity(0.1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isWeb
                ? 32.0
                : isTablet
                    ? 24.0
                    : 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: Obx(
                () => controller.isLoading.value
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Center(
                          child: SpinKitDoubleBounce(
                            color: AppColors.primary,
                            size: isWeb ? 60 : 40,
                          ),
                        ),
                      )
                    : controller.errorMessage.value.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    controller.errorMessage.value,
                                    style: AppStyles.body.copyWith(
                                      fontSize: isWeb
                                          ? 16
                                          : isTablet
                                              ? 15
                                              : 14,
                                      color: AppColors.error,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomButton(
                                    text: controller.errorMessage.value
                                            .contains('login')
                                        ? 'Login'
                                        : 'Coba Lagi',
                                    onPressed: controller.errorMessage.value
                                            .contains('login')
                                        ? () => Get.offAllNamed('/login')
                                        : () => controller.fetchDeviceDetail(
                                            Get.arguments['deviceId']),
                                    width: isWeb ? 300 : double.infinity,
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(duration: 500.ms)
                        : controller.device.value == null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 40.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons
                                            .device_unknown, // Diperbaiki dari Icons.devices_off
                                        size: isWeb ? 60 : 50,
                                        color: AppColors.error,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Data perangkat tidak tersedia',
                                        style: AppStyles.body.copyWith(
                                          fontSize: isWeb
                                              ? 16
                                              : isTablet
                                                  ? 15
                                                  : 14,
                                          color: AppColors.error,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ).animate().fadeIn(duration: 500.ms)
                            : _isLocaleInitialized
                                ? _buildDeviceDetail(
                                    controller.device.value!, isWeb, isTablet)
                                : Center(
                                    child: SpinKitDoubleBounce(
                                      color: AppColors.primary,
                                      size: isWeb ? 60 : 40,
                                    ),
                                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceDetail(
      DeviceDetailModel device, bool isWeb, bool isTablet) {
    print('Merender detail perangkat: ${device.toJson()}');
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border:
            Border.all(color: AppColors.primary.withOpacity(0.5), width: 1.5),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.devices,
                    size: isWeb
                        ? 24
                        : isTablet
                            ? 22
                            : 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Detail Perangkat',
                    style: AppStyles.title.copyWith(
                      fontSize: isWeb
                          ? 20
                          : isTablet
                              ? 18
                              : 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                  'ID Perangkat', device.deviceId?.toString(), isWeb, isTablet),
              _buildDetailRow('Merek', device.brand, isWeb, isTablet),
              _buildDetailRow(
                  'Nomor Seri', device.serialNumber, isWeb, isTablet),
              _buildDetailRow('Kode Aset', device.assetCode, isWeb, isTablet),
              _buildDetailRow(
                  'Tanggal Penugasan', formattedDate, isWeb, isTablet),
              _buildDetailRow('Spesifikasi 1', device.spec1, isWeb, isTablet),
              _buildDetailRow('Spesifikasi 2', device.spec2, isWeb, isTablet),
              _buildDetailRow('Spesifikasi 3', device.spec3, isWeb, isTablet),
              if (device.spec4 != null)
                _buildDetailRow('Spesifikasi 4', device.spec4, isWeb, isTablet),
              if (device.spec5 != null)
                _buildDetailRow('Spesifikasi 5', device.spec5, isWeb, isTablet),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Kembali',
                onPressed: () => Get.back(),
                width: isWeb ? 300 : double.infinity,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(
          begin: 0.2,
          end: 0,
          duration: 600.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildDetailRow(
      String label, String? value, bool isWeb, bool isTablet) {
    print('Merender baris detail: $label = $value');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyles.body.copyWith(
              fontSize: isWeb
                  ? 16
                  : isTablet
                      ? 15
                      : 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value ?? 'Tidak Tersedia',
              style: AppStyles.body.copyWith(
                fontSize: isWeb
                    ? 16
                    : isTablet
                        ? 15
                        : 14,
                color: value == null ? AppColors.error : Colors.white70,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
