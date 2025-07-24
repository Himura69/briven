import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../admin/controllers/admin_assignment_controller.dart';

class AdminAssignmentDetailScreen extends StatelessWidget {
  final int assignmentId;

  const AdminAssignmentDetailScreen({super.key, required this.assignmentId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminAssignmentsController());

    // Ambil detail data
    controller.fetchAssignmentDetail(assignmentId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          'Detail Assignment',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return const Center(child: LoadingIndicator());
        }
        if (controller.detailError.isNotEmpty) {
          return Center(
              child: Text(controller.detailError.value,
                  style: const TextStyle(color: Colors.red)));
        }

        final detail = controller.assignmentDetail.value;
        if (detail == null) {
          return const Center(
              child: Text('Detail assignment tidak ditemukan.'));
        }

        final letters = detail.assignmentLetters ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${detail.brand} ${detail.assetCode}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Serial: ${detail.serialNumber}',
                          style: const TextStyle(color: Colors.black54)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text('User: ${detail.assignedTo}',
                                  style: const TextStyle(fontSize: 14))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text('Cabang: ${detail.unitName}',
                                  style: const TextStyle(fontSize: 14))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.event, color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text('Tanggal: ${detail.assignedDate}',
                                  style: const TextStyle(fontSize: 14))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Status: ${detail.status ?? "Tidak Ada"}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: (detail.status ?? '')
                                            .toLowerCase() ==
                                        'digunakan'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (detail.notes != null && detail.notes!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text('Catatan: ${detail.notes!}',
                              style: const TextStyle(fontSize: 14)),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Surat Penugasan (assignmentLetters)
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Surat Penugasan',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      if (letters.isEmpty)
                        const Text('Tidak ada surat penugasan.'),
                      ...letters.map((letter) => Card(
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: const Icon(Icons.picture_as_pdf,
                                  color: Colors.redAccent),
                              title: Text(letter.letterNumber ?? '-'),
                              subtitle: Text(
                                  '${letter.assignmentType ?? '-'} • ${letter.letterDate ?? '-'}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.open_in_new,
                                    color: Colors.blueAccent),
                                onPressed: () async {
                                  if (letter.fileUrl != null) {
                                    final uri = Uri.parse(letter.fileUrl!);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri,
                                          mode: LaunchMode.externalApplication);
                                    } else {
                                      Get.snackbar('Error',
                                          'Tidak bisa membuka file surat.',
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                  }
                                },
                              ),
                            ),
                          )),
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
