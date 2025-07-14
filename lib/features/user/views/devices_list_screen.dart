import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    final isWeb = screenWidth > 900;
    final isTablet = screenWidth >= 600 && screenWidth <= 900;
    final contentWidth = isWeb ? screenWidth * 0.6 : screenWidth * 0.9;

    // Controller untuk TextField pencarian
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: NavBar(),
      ),
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              AppColors.gradientEnd.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb
                  ? 32.0
                  : isTablet
                      ? 24.0
                      : 16.0,
              vertical: isWeb
                  ? 32.0
                  : isTablet
                      ? 24.0
                      : 16.0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .start, // Pastikan konten dimulai dari atas
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kolom Pencarian
                  Obx(
                    () => TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari berdasarkan merek atau kategori...',
                        hintStyle: AppStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: isWeb
                              ? 16
                              : isTablet
                                  ? 15
                                  : 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                          size: isWeb ? 24 : 20,
                        ),
                        suffixIcon: controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: AppColors.textSecondary,
                                  size: isWeb ? 24 : 20,
                                ),
                                onPressed: () {
                                  searchController.clear();
                                  controller.filterDevices('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.searchBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (value) {
                        controller.filterDevices(value);
                      },
                    ).animate().fadeIn(duration: 500.ms),
                  ),
                  const SizedBox(height: 24),
                  // Daftar Perangkat
                  Obx(
                    () => controller.isLoading.value
                        ? Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center(
                              child: SpinKitDoubleBounce(
                                color: AppColors.primary,
                                size: isWeb
                                    ? 60
                                    : isTablet
                                        ? 50
                                        : 40,
                              ),
                            ),
                          ).animate().fadeIn(duration: 500.ms)
                        : controller.filteredDevices.isEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  Icon(
                                    Icons.devices_other,
                                    size: isWeb
                                        ? 80
                                        : isTablet
                                            ? 70
                                            : 60,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    controller.errorMessage.value.isEmpty
                                        ? 'Tidak ada perangkat tersedia'
                                        : controller.errorMessage.value,
                                    style: AppStyles.body.copyWith(
                                      fontSize: isWeb
                                          ? 16
                                          : isTablet
                                              ? 15
                                              : 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(height: 16),
                                  if (controller.errorMessage.value
                                      .contains('login'))
                                    CustomButton(
                                      text: 'Login',
                                      icon: Icons.login,
                                      onPressed: () =>
                                          Get.offAllNamed('/login'),
                                      width: isWeb ? 300 : contentWidth,
                                    )
                                  else
                                    CustomButton(
                                      text: 'Coba Lagi',
                                      icon: Icons.refresh,
                                      onPressed: controller.fetchDevices,
                                      width: isWeb ? 300 : contentWidth,
                                    ),
                                ],
                              ).animate().fadeIn(duration: 500.ms)
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isWeb
                                      ? 3
                                      : isTablet
                                          ? 2
                                          : 1,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: isWeb
                                      ? 2.4
                                      : isTablet
                                          ? 2.2
                                          : 2.0,
                                ),
                                itemCount: controller.filteredDevices.length,
                                itemBuilder: (context, index) {
                                  final device =
                                      controller.filteredDevices[index];
                                  return _buildDeviceCard(
                                          device, isWeb, isTablet)
                                      .animate()
                                      .slideX(
                                        begin: 0.2,
                                        end: 0,
                                        duration: 400.ms,
                                        delay: (index * 100).ms,
                                      );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard(DeviceModel device, bool isWeb, bool isTablet) {
    print('Merender perangkat: ${device.toJson()}');
    return MouseRegion(
      onEnter: (_) {}, // Untuk efek hover di web
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.border, width: 1),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: device.deviceId != null
                ? () {
                    print('Navigasi ke detail perangkat: ${device.deviceId}');
                    Get.toNamed(
                      '/device_detail',
                      arguments: {'deviceId': device.deviceId},
                    );
                  }
                : () {
                    print('deviceId null untuk perangkat: ${device.toJson()}');
                  },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                      Expanded(
                        child: Text(
                          device.brand ?? 'Perangkat Tidak Dikenal',
                          style: AppStyles.label.copyWith(
                            fontSize: isWeb
                                ? 16
                                : isTablet
                                    ? 15
                                    : 14,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Nomor Seri: ${device.serialNumber ?? 'Tanpa Serial'}',
                    style: AppStyles.sublabel.copyWith(
                      fontSize: isWeb
                          ? 13
                          : isTablet
                              ? 12
                              : 11,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kategori: ${device.categoryName ?? 'Tipe Tidak Dikenal'}',
                    style: AppStyles.sublabel.copyWith(
                      fontSize: isWeb
                          ? 13
                          : isTablet
                              ? 12
                              : 11,
                      color: Colors.white70,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: isWeb
                          ? 18
                          : isTablet
                              ? 16
                              : 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
