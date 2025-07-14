import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/nav_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/loan_history_controller.dart';
import '../models/loan_history_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
    final DashboardController controller = Get.put(DashboardController());
    final LoanHistoryController loanHistoryController =
        Get.put(LoanHistoryController());
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 900;
    final isTablet = screenWidth >= 600 && screenWidth <= 900;
    final contentWidth = isWeb ? screenWidth * 0.6 : screenWidth * 0.9;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: NavBar(),
      ),
      backgroundColor: const Color.fromARGB(
          0, 245, 245, 245), // Pastikan Scaffold transparan
      body: Container(
        width: double.infinity,
        height: double.infinity, // Pastikan full layar
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.background,
              const Color.fromARGB(255, 230, 244, 255).withOpacity(0.3)
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
                    : controller.summary.value == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    controller.errorMessage.value.isEmpty
                                        ? 'Gagal memuat dashboard'
                                        : controller.errorMessage.value,
                                    style: AppStyles.body.copyWith(
                                      fontSize: isWeb ? 16 : 14,
                                      color: AppColors.error,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomButton(
                                    text: 'Coba Lagi',
                                    onPressed: () =>
                                        controller.fetchHomeSummary(),
                                    width: isWeb ? 300 : double.infinity,
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(duration: 500.ms)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Kartu Perangkat Aktif dan Riwayat Peminjaman
                              isWeb
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: _buildActiveDevicesCard(
                                            controller,
                                            isWeb,
                                            isTablet,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _buildLoanHistoryCard(
                                            loanHistoryController,
                                            isWeb,
                                            isTablet,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        _buildActiveDevicesCard(
                                          controller,
                                          isWeb,
                                          isTablet,
                                        ),
                                        const SizedBox(height: 24),
                                        _buildLoanHistoryCard(
                                          loanHistoryController,
                                          isWeb,
                                          isTablet,
                                        ),
                                      ],
                                    ),
                            ],
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveDevicesCard(
    DashboardController controller,
    bool isWeb,
    bool isTablet,
  ) {
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
                    Icons.device_hub,
                    size: isWeb
                        ? 24
                        : isTablet
                            ? 22
                            : 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Perangkat Aktif',
                    style: AppStyles.title.copyWith(
                      fontSize: isWeb
                          ? 18
                          : isTablet
                              ? 17
                              : 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() => Text(
                    controller.summary.value!.activeDevicesCount.toString(),
                    style: AppStyles.title.copyWith(
                      fontSize: isWeb
                          ? 32
                          : isTablet
                              ? 28
                              : 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
              const SizedBox(height: 8),
              Text(
                'Perangkat yang sedang digunakan',
                style: AppStyles.body.copyWith(
                  fontSize: isWeb
                      ? 14
                      : isTablet
                          ? 13
                          : 12,
                  color: Colors.white70,
                ),
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

  Widget _buildLoanHistoryCard(
    LoanHistoryController controller,
    bool isWeb,
    bool isTablet,
  ) {
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
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            childrenPadding: const EdgeInsets.only(bottom: 8.0),
            title: Row(
              children: [
                Icon(
                  Icons.history,
                  size: isWeb
                      ? 24
                      : isTablet
                          ? 22
                          : 20,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  'Riwayat Perangkat',
                  style: AppStyles.title.copyWith(
                    fontSize: isWeb
                        ? 18
                        : isTablet
                            ? 17
                            : 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            subtitle: Obx(() => Text(
                  '${controller.loanHistory.length} Peminjaman',
                  style: AppStyles.body.copyWith(
                    fontSize: isWeb
                        ? 14
                        : isTablet
                            ? 13
                            : 12,
                    color: Colors.white70,
                  ),
                )),
            children: [
              Obx(() => controller.isLoading.value
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: SpinKitDoubleBounce(
                          color: AppColors.primary,
                          size: isWeb ? 40 : 30,
                        ),
                      ),
                    )
                  : controller.errorMessage.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
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
                                text: 'Coba Lagi',
                                onPressed: () => controller.fetchLoanHistory(),
                                width: isWeb ? 200 : double.infinity,
                              ),
                            ],
                          ),
                        )
                      : controller.loanHistory.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.history_toggle_off,
                                    size: isWeb ? 60 : 50,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tidak ada riwayat peminjaman',
                                    style: AppStyles.body.copyWith(
                                      fontSize: isWeb
                                          ? 16
                                          : isTablet
                                              ? 15
                                              : 14,
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.loanHistory.length > 5
                                  ? 5
                                  : controller.loanHistory.length,
                              itemBuilder: (context, index) {
                                final loan = controller.loanHistory[index];
                                String? formattedAssignedDate;
                                String? formattedReturnedDate;
                                try {
                                  if (loan.assignedDate != null) {
                                    formattedAssignedDate = DateFormat(
                                            'd MMMM yyyy', 'id_ID')
                                        .format(
                                            DateTime.parse(loan.assignedDate!));
                                  }
                                  if (loan.returnedDate != null) {
                                    formattedReturnedDate = DateFormat(
                                            'd MMMM yyyy', 'id_ID')
                                        .format(
                                            DateTime.parse(loan.returnedDate!));
                                  }
                                } catch (e) {
                                  formattedAssignedDate = loan.assignedDate ??
                                      'Format Tanggal Tidak Valid';
                                  formattedReturnedDate =
                                      loan.returnedDate ?? 'Belum Dikembalikan';
                                }
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  loan.deviceName,
                                                  style:
                                                      AppStyles.body.copyWith(
                                                    fontSize: isWeb
                                                        ? 16
                                                        : isTablet
                                                            ? 15
                                                            : 14,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'SN: ${loan.serialNumber}',
                                                  style:
                                                      AppStyles.body.copyWith(
                                                    fontSize: isWeb
                                                        ? 14
                                                        : isTablet
                                                            ? 13
                                                            : 12,
                                                    color: Colors.white70,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'Pinjam: $formattedAssignedDate',
                                                  style:
                                                      AppStyles.body.copyWith(
                                                    fontSize: isWeb
                                                        ? 14
                                                        : isTablet
                                                            ? 13
                                                            : 12,
                                                    color: Colors.white70,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'Kembali: ${formattedReturnedDate ?? 'Belum Dikembalikan'}',
                                                  style:
                                                      AppStyles.body.copyWith(
                                                    fontSize: isWeb
                                                        ? 14
                                                        : isTablet
                                                            ? 13
                                                            : 12,
                                                    color:
                                                        formattedReturnedDate ==
                                                                null
                                                            ? AppColors.accent
                                                            : Colors.white70,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (index <
                                        (controller.loanHistory.length > 5
                                            ? 4
                                            : controller.loanHistory.length -
                                                1))
                                      const Divider(
                                        color: Colors.white24,
                                        thickness: 1,
                                        height: 16,
                                        indent: 16,
                                        endIndent: 16,
                                      ),
                                  ],
                                );
                              },
                            )),
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
}
