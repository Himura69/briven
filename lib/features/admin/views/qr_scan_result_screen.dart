import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../admin/controllers/qr_scanner_controller.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart'; // Pastikan ini di-import

class QrScanResultScreen extends StatelessWidget {
  const QrScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QrScannerController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Scan QR"),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed(AppRoutes.adminRoot);
          },
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final data = controller.scanResult.value;
        if (data == null) {
          return const Center(child: Text("Tidak ada data tersedia."));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCard(
                title: "Informasi Perangkat",
                children: [
                  _buildInfoRow("Nama", data.device.name),
                  _buildInfoRow("Tipe", data.device.type),
                  _buildInfoRow("Serial Number", data.device.serialNumber),
                  _buildStatusRow("Status", data.device.status),
                  _buildInfoRow("Kondisi", data.device.condition),
                  _buildInfoRow(
                    "Spesifikasi",
                    [
                      data.device.spec1,
                      data.device.spec2,
                      data.device.spec3,
                      data.device.spec4,
                      data.device.spec5,
                    ].where((e) => e?.isNotEmpty ?? false).join(", "),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: "Sedang Ditugaskan Kepada",
                children: data.device.assignedTo != null
                    ? [
                        _buildInfoRow(
                            "Nama", data.device.assignedTo?.name ?? "-"),
                        _buildInfoRow("PN", data.device.assignedTo?.pn ?? "-"),
                        _buildInfoRow("Departemen",
                            data.device.assignedTo?.department ?? "-"),
                        _buildInfoRow(
                            "Posisi", data.device.assignedTo?.position ?? "-"),
                        _buildInfoRow(
                            "Cabang", data.device.assignedTo?.branch ?? "-"),
                      ]
                    : [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text("Belum ditugaskan ke siapa pun."),
                        ),
                      ],
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: "Riwayat Penugasan",
                children: data.history.map((h) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    leading:
                        const Icon(Icons.history, color: AppColors.primary),
                    title: Text("${h.action.toUpperCase()} oleh ${h.user}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tanggal: ${h.date}"),
                        Text("Disetujui: ${h.approver}"),
                        if (h.note.isNotEmpty) Text("Catatan: ${h.note}"),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                )),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 110,
              child: Text("$label:",
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String status) {
    final color = _getStatusColor(status);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 110,
              child: Text("$label:",
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'digunakan':
        return Colors.green;
      case 'idle':
      case 'tersedia':
        return Colors.orange;
      case 'broken':
      case 'rusak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
