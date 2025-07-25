import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../admin/controllers/admin_assignment_controller.dart';
import '../../admin/models/admin_assignment_detail_model.dart';

class AdminAssignmentDetailScreen extends StatelessWidget {
  final int assignmentId;

  const AdminAssignmentDetailScreen({super.key, required this.assignmentId});

  Future<void> _openPdf(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        "Error",
        "Tidak bisa membuka file PDF",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminAssignmentsController>();

    // Ambil data detail
    controller.fetchAssignmentDetail(assignmentId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Assignment'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: const Color(0xFFF8F9FB),
      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return const Center(child: LoadingIndicator());
        }
        if (controller.detailError.isNotEmpty) {
          return Center(
            child: Text(controller.detailError.value,
                style: const TextStyle(color: Colors.red)),
          );
        }

        final AdminAssignmentDetailModel? detail =
            controller.assignmentDetail.value;

        if (detail == null) {
          return const Center(
            child: Text('Data detail tidak ditemukan'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${detail.brand} ${detail.serialNumber}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Asset Code: ${detail.assetCode}'),
                      Text('Assigned To: ${detail.assignedTo}'),
                      Text('Unit: ${detail.unitName}'),
                      Text('Assigned Date: ${detail.assignedDate}'),
                      if (detail.returnedDate != null)
                        Text('Returned Date: ${detail.returnedDate}'),
                      Text('Status: ${detail.status ?? '-'}'),
                      if (detail.notes != null) Text('Notes: ${detail.notes}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Daftar surat penugasan
              if (detail.assignmentLetters.isNotEmpty) ...[
                const Text(
                  'Surat Terkait:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Column(
                  children: detail.assignmentLetters.map((letter) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 1,
                      child: ListTile(
                        leading: const Icon(Icons.picture_as_pdf,
                            color: Colors.redAccent),
                        title: Text(letter.letterNumber),
                        subtitle: Text(
                            'Jenis: ${letter.assignmentType}\nTanggal: ${letter.letterDate}'),
                        trailing: ElevatedButton.icon(
                          icon: const Icon(Icons.open_in_browser),
                          label: const Text("Lihat Surat"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => _openPdf(letter.fileUrl),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
