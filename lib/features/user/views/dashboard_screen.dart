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
    final LoanHistoryController loanHistoryController = Get.put(LoanHistoryController());
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    final contentWidth = isWeb ? screenWidth * 0.6 : screenWidth * 0.9;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: NavBar(),
      ),
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.background, AppColors.gradientEnd.withOpacity(0.1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(isWeb ? 32.0 : isTablet ? 24.0 : 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Obx(
                  () => controller.isLoading.value
                      ? Center(
                          child: SpinKitDoubleBounce(
                            color: AppColors.primary,
                            size: isWeb ? 60 : 40,
                          ),
                        )
                      : controller.summary.value == null
                          ? Center(
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
                                    onPressed: () => controller.fetchHomeSummary(),
                                    width: isWeb ? 300 : double.infinity,
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(duration: 500.ms)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Pesan Selamat Datang
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: isWeb ? 24 : 20,
                                      backgroundColor: AppColors.primary,
                                      child: Icon(Icons.person, color: Colors.white, size: isWeb ? 28 : 24),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Selamat datang, ${controller.userName.value}',
                                        style: AppStyles.title.copyWith(
                                          fontSize: isWeb ? 28 : isTablet ? 24 : 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
                                const SizedBox(height: 24),
                                // Grid Kartu
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: isWeb ? 2 : isTablet ? 2 : 1,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: isWeb ? 1.4 : isTablet ? 1.5 : 1.6,
                                  children: [
                                    _buildSummaryCard(
                                      title: 'Perangkat Aktif',
                                      value: controller.summary.value!.activeDevicesCount.toString(),
                                      icon: Icons.devices,
                                      isWeb: isWeb,
                                      isTablet: isTablet,
                                    ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                                    _buildSummaryCard(
                                      title: 'Riwayat Perangkat',
                                      value: controller.summary.value!.deviceHistoryCount.toString(),
                                      icon: Icons.history,
                                      isWeb: isWeb,
                                      isTablet: isTablet,
                                    ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                // Daftar Riwayat Peminjaman
                                _isLocaleInitialized
                                    ? _buildLoanHistoryList(loanHistoryController, isWeb, isTablet, contentWidth)
                                    : Center(
                                        child: SpinKitDoubleBounce(
                                          color: AppColors.primary,
                                          size: isWeb ? 60 : 40,
                                        ),
                                      ),
                              ],
                            ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isWeb,
    required bool isTablet,
  }) {
    return MouseRegion(
      onEnter: (_) {}, // Untuk efek hover di web
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: isWeb ? 48 : isTablet ? 40 : 36, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppStyles.label.copyWith(
                    fontSize: isWeb ? 18 : isTablet ? 16 : 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppStyles.title.copyWith(
                    fontSize: isWeb ? 22 : isTablet ? 20 : 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoanHistoryList(LoanHistoryController controller, bool isWeb, bool isTablet, double contentWidth) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Peminjaman',
            style: AppStyles.title.copyWith(
              fontSize: isWeb ? 22 : isTablet ? 20 : 18,
            ),
          ),
          const SizedBox(height: 16),
          controller.isLoading.value
              ? Center(
                  child: SpinKitDoubleBounce(
                    color: AppColors.primary,
                    size: isWeb ? 60 : 40,
                  ),
                ).animate().fadeIn(duration: 500.ms)
              : controller.errorMessage.value.isNotEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Text(
                            controller.errorMessage.value,
                            style: AppStyles.body.copyWith(
                              fontSize: isWeb ? 16 : isTablet ? 15 : 14,
                              color: AppColors.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          if (controller.errorMessage.value.contains('login'))
                            CustomButton(
                              text: 'Login',
                              onPressed: () => Get.offAllNamed('/login'),
                              width: isWeb ? 300 : double.infinity,
                            )
                          else
                            CustomButton(
                              text: 'Coba Lagi',
                              onPressed: () => controller.fetchLoanHistory(),
                              width: isWeb ? 300 : double.infinity,
                            ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 500.ms)
                  : controller.loanHistory.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.history_toggle_off,
                                size: isWeb ? 80 : 60,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada riwayat peminjaman',
                                style: AppStyles.body.copyWith(
                                  fontSize: isWeb ? 16 : isTablet ? 15 : 14,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              CustomButton(
                                text: 'Pinjam Perangkat',
                                onPressed: () => Get.toNamed('/loan'), // Asumsi ada rute untuk peminjaman
                                width: isWeb ? 300 : double.infinity,
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 500.ms)
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.loanHistory.length,
                          itemBuilder: (context, index) {
                            final loan = controller.loanHistory[index];
                            print('Merender riwayat peminjaman: ${loan.toJson()}');
                            String? formattedAssignedDate;
                            String? formattedReturnedDate;
                            try {
                              if (loan.assignedDate != null) {
                                formattedAssignedDate = DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.parse(loan.assignedDate!));
                              }
                              if (loan.returnedDate != null) {
                                formattedReturnedDate = DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.parse(loan.returnedDate!));
                              }
                            } catch (e) {
                              print('Error parsing date: $e');
                              formattedAssignedDate = loan.assignedDate != null ? 'Format Tanggal Tidak Valid' : null;
                              formattedReturnedDate = loan.returnedDate != null ? 'Format Tanggal Tidak Valid' : null;
                            }
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailRow('Nama Perangkat', loan.deviceName, isWeb, isTablet, icon: Icons.devices),
                                    const Divider(height: 8),
                                    _buildDetailRow('Nomor Seri', loan.serialNumber, isWeb, isTablet, icon: Icons.tag),
                                    const Divider(height: 8),
                                    _buildDetailRow('Tanggal Pinjam', formattedAssignedDate, isWeb, isTablet, icon: Icons.calendar_today),
                                    const Divider(height: 8),
                                    _buildDetailRow(
                                      'Tanggal Kembali',
                                      formattedReturnedDate ?? 'Belum Dikembalikan',
                                      isWeb,
                                      isTablet,
                                      icon: Icons.calendar_today,
                                      textColor: formattedReturnedDate == null ? AppColors.accent : null,
                                    ),
                                  ],
                                ),
                              ),
                            ).animate().slideX(
                                  begin: 0.2,
                                  end: 0,
                                  duration: 400.ms,
                                  delay: (index * 100).ms,
                                );
                          },
                        ),
          const SizedBox(height: 16),
          Obx(() {
            final meta = controller.meta.value;
            print('Rendering tombol paginasi: currentPage=${controller.currentPage.value}, meta=${meta?.toJson() ?? 'null'}');
            if (meta == null || meta.lastPage <= 1) {
              print('Tombol paginasi tidak ditampilkan: meta=$meta');
              return const SizedBox.shrink();
            }
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: 'Sebelumnya',
                    icon: Icons.arrow_back,
                    onPressed: controller.currentPage.value > 1
                        ? () {
                            print('Tombol Sebelumnya diklik, currentPage: ${controller.currentPage.value}');
                            controller.goToPreviousPage();
                          }
                        : null,
                    width: isWeb ? 150 : (contentWidth / 2 - 8),
                  ),
                  Text(
                    'Halaman ${controller.currentPage.value}/${meta.lastPage}',
                    style: AppStyles.body.copyWith(
                      fontSize: isWeb ? 16 : isTablet ? 15 : 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  CustomButton(
                    text: 'Selanjutnya',
                    icon: Icons.arrow_forward,
                    onPressed: controller.currentPage.value < meta.lastPage
                        ? () {
                            print('Tombol Selanjutnya diklik, currentPage: ${controller.currentPage.value}, lastPage: ${meta.lastPage}');
                            controller.goToNextPage();
                          }
                        : null,
                    width: isWeb ? 150 : (contentWidth / 2 - 8),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms);
          }),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String? value,
    bool isWeb,
    bool isTablet, {
    Color? textColor,
    IconData? icon,
  }) {
    print('Merender baris riwayat: $label = $value');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: isWeb ? 20 : 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: AppStyles.label.copyWith(
                  fontSize: isWeb ? 16 : isTablet ? 15 : 14,
                ),
              ),
            ],
          ),
          Flexible(
            child: Text(
              value ?? 'Tidak Tersedia',
              style: AppStyles.sublabel.copyWith(
                fontSize: isWeb ? 16 : isTablet ? 15 : 14,
                color: value == null ? AppColors.error : (textColor ?? AppColors.textSecondary),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}