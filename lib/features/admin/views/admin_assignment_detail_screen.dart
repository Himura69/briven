import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../controllers/admin_assignment_detail_controller.dart';
import '../models/admin_assignment_detail_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminAssignmentDetailScreen extends StatelessWidget {
  final int assignmentId;

  const AdminAssignmentDetailScreen({super.key, required this.assignmentId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminAssignmentDetailController());

    // Ambil data detail saat halaman dibuka
    controller.fetchAssignmentDetail(assignmentId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Detail Assignment',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
        final detail = controller.assignmentDetail.value;
        if (detail == null) {
          return const Center(
            child: Text('Data assignment tidak ditemukan.'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${detail.brand} (${detail.assetCode})',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Serial: ${detail.serialNumber}'),
                      Text('User: ${detail.assignedTo}'),
                      Text('Cabang: ${detail.unitName}'),
                      Text('Tanggal Pinjam: ${detail.assignedDate}'),
                      Text(
                        'Status: ${detail.status ?? 'Tidak Ada'}',
                        style: TextStyle(
                          color:
                              (detail.status ?? '').toLowerCase() == 'digunakan'
                                  ? Colors.green
                                  : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (detail.returnedDate != null)
                        Text('Tanggal Kembali: ${detail.returnedDate}'),
                      if (detail.notes != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('Catatan: ${detail.notes}'),
                        ),
                    ],
                  ),
                ),
              ),

              // Assignment Letters Section
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Surat Penugasan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (detail.assignmentLetters.isEmpty)
                        const Text(
                          'Tidak ada surat terkait.',
                          style: TextStyle(color: Colors.black54),
                        )
                      else
                        Column(
                          children: detail.assignmentLetters.map((letter) {
                            return ListTile(
                              leading: const Icon(Icons.picture_as_pdf,
                                  color: Colors.redAccent),
                              title: Text('${letter.assignmentType}'),
                              subtitle: Text(
                                  'No: ${letter.letterNumber} • ${letter.letterDate}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.open_in_new,
                                    color: Colors.blueAccent),
                                onPressed: () async {
                                  final url = Uri.parse(letter.fileUrl);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url,
                                        mode: LaunchMode.externalApplication);
                                  } else {
                                    Get.snackbar(
                                      'Error',
                                      'Gagal membuka file surat.',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
