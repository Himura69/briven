import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/nav_bar.dart';
import 'request_check_modal.dart';

class DeviceDetailScreen extends StatelessWidget {
  const DeviceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Device Details',
                    style: AppStyles.title.copyWith(
                      fontSize: isWeb ? 28 : 24,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Gambar Perangkat (Placeholder)
                  Container(
                    height: isWeb ? 200 : 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage(
                            'assets/images/device.png'), // Ganti dengan path gambar
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Informasi Perangkat
                  _buildDetailField('Device Name', 'Laptop XYZ', isWeb),
                  _buildDetailField('Serial Number', 'SN123456789', isWeb),
                  _buildDetailField('Assigned Date', '2025-01-01', isWeb),
                  _buildDetailField('Status', 'Active', isWeb),
                  _buildDetailField('Condition', 'Good', isWeb),
                  _buildDetailField(
                      'Specifications', '16GB RAM, 512GB SSD, Intel i7', isWeb),
                  const SizedBox(height: 24),
                  // Tombol Request Check
                  CustomButton(
                    text: 'Request Check',
                    onPressed: () {
                      Get.dialog(const RequestCheckModal(
                          deviceId: 'SN123456789')); // Placeholder deviceId
                    },
                    width: isWeb ? 300 : double.infinity,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value, bool isWeb) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyles.body.copyWith(
              fontSize: isWeb ? 16 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppStyles.body.copyWith(
              fontSize: isWeb ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
