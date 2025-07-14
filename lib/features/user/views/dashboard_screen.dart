import 'package:flutter/material.dart';
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
                    : controller.summary.value == null
                        ? Center(
                            child: Column(
                              children: [
                                Text(
                                  controller.errorMessage.value.isEmpty
                                      ? 'Failed to load dashboard'
                                      : controller.errorMessage.value,
                                  style: AppStyles.body.copyWith(
                                    fontSize: isWeb ? 16 : 14,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                CustomButton(
                                  text: 'Retry',
                                  onPressed: () =>
                                      controller.fetchHomeSummary(),
                                  width: isWeb ? 300 : double.infinity,
                                ),
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Pesan Selamat Datang
                              Text(
                                'Selamat datang, ${controller.userName.value}',
                                style: AppStyles.title.copyWith(
                                  fontSize: isWeb ? 28 : 24,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Grid Kartu
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: isWeb ? 2 : 1,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.4,
                                children: [
                                  _buildSummaryCard(
                                    title: 'Active Devices',
                                    value: controller
                                        .summary.value!.activeDevicesCount
                                        .toString(),
                                    icon: Icons.devices,
                                    isWeb: isWeb,
                                  ),
                                  _buildSummaryCard(
                                    title: 'Device History',
                                    value: controller
                                        .summary.value!.deviceHistoryCount
                                        .toString(),
                                    icon: Icons.history,
                                    isWeb: isWeb,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Daftar Riwayat Peminjaman
                              _isLocaleInitialized
                                  ? _buildLoanHistoryList(loanHistoryController,
                                      isWeb, contentWidth)
                                  : const Center(
                                      child: CircularProgressIndicator()),
                            ],
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
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isWeb ? 40 : 32, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppStyles.body.copyWith(
                fontSize: isWeb ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppStyles.title.copyWith(
                fontSize: isWeb ? 20 : 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanHistoryList(
      LoanHistoryController controller, bool isWeb, double contentWidth) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Peminjaman',
            style: AppStyles.body.copyWith(
              fontSize: isWeb ? 20 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.errorMessage.value.isNotEmpty
                  ? Center(
                      child: Column(
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
                    )
                  : controller.loanHistory.isEmpty
                      ? Center(
                          child: Text(
                            'Tidak ada riwayat peminjaman',
                            style: AppStyles.body.copyWith(
                              fontSize: isWeb ? 16 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.loanHistory.length,
                          itemBuilder: (context, index) {
                            final loan = controller.loanHistory[index];
                            print(
                                'Merender riwayat peminjaman: ${loan.toJson()}');
                            String? formattedAssignedDate;
                            String? formattedReturnedDate;
                            try {
                              if (loan.assignedDate != null) {
                                formattedAssignedDate = DateFormat(
                                        'd MMMM yyyy', 'id_ID')
                                    .format(DateTime.parse(loan.assignedDate!));
                              }
                              if (loan.returnedDate != null) {
                                formattedReturnedDate = DateFormat(
                                        'd MMMM yyyy', 'id_ID')
                                    .format(DateTime.parse(loan.returnedDate!));
                              }
                            } catch (e) {
                              print('Error parsing date: $e');
                              formattedAssignedDate = loan.assignedDate != null
                                  ? 'Format Tanggal Tidak Valid'
                                  : null;
                              formattedReturnedDate = loan.returnedDate != null
                                  ? 'Format Tanggal Tidak Valid'
                                  : null;
                            }
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailRow('Nama Perangkat',
                                        loan.deviceName, isWeb),
                                    _buildDetailRow(
                                        'Nomor Seri', loan.serialNumber, isWeb),
                                    _buildDetailRow('Tanggal Pinjam',
                                        formattedAssignedDate, isWeb),
                                    _buildDetailRow('Tanggal Kembali',
                                        formattedReturnedDate, isWeb),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
          const SizedBox(height: 16),
          Obx(() {
            final meta = controller.meta.value;
            print(
                'Rendering tombol paginasi: currentPage=${controller.currentPage.value}, meta=${meta?.toJson() ?? 'null'}');
            if (meta == null || meta.lastPage <= 1) {
              print('Tombol paginasi tidak ditampilkan: meta=$meta');
              return const SizedBox.shrink();
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  text: 'Sebelumnya',
                  onPressed: controller.currentPage.value > 1
                      ? () {
                          print(
                              'Tombol Sebelumnya diklik, currentPage: ${controller.currentPage.value}');
                          controller.goToPreviousPage();
                        }
                      : null,
                  width: isWeb ? 150 : (contentWidth / 2 - 8),
                ),
                CustomButton(
                  text: 'Selanjutnya',
                  onPressed: controller.currentPage.value < meta.lastPage
                      ? () {
                          print(
                              'Tombol Selanjutnya diklik, currentPage: ${controller.currentPage.value}, lastPage: ${meta.lastPage}');
                          controller.goToNextPage();
                        }
                      : null,
                  width: isWeb ? 150 : (contentWidth / 2 - 8),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value, bool isWeb,
      {Color? textColor}) {
    print('Merender baris riwayat: $label = $value');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
