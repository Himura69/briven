import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../services/api_service.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final int assignmentId;

  const AssignmentDetailScreen({super.key, required this.assignmentId});

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  late Future<Map<String, dynamic>> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _fetchDetail();
  }

  Future<Map<String, dynamic>> _fetchDetail() {
    return Get.find<ApiService>()
        .getDeviceAssignmentDetail(widget.assignmentId);
  }

  void _refreshDetail() {
    setState(() {
      _detailFuture = _fetchDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _detailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Detail Assignment")),
            body: const Center(child: Text("Gagal memuat data assignment.")),
          );
        }

        final data = snapshot.data!;
        final deviceInfo = '${data['assetCode']} - ${data['brand']}';
        final user = data['assignedTo'] ?? '-';
        final unit = data['unitName'] ?? '-';
        final assignedDate =
            data['assignedDate']?.toString().split('T').first ?? '-';
        final notes = data['notes'] ?? '-';
        final letters = data['assignmentLetters'] as List? ?? [];

        return Scaffold(
          appBar: AppBar(title: const Text("Detail Assignment")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
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
                        _buildRow("📱 Perangkat", deviceInfo),
                        _buildRow("👤 Pengguna", user),
                        _buildRow("🏢 Unit", unit),
                        _buildRow("📅 Tanggal Assign", assignedDate),
                        _buildRow("📝 Catatan", notes),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "📄 Surat Penugasan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (letters.isEmpty)
                  const Text("Tidak ada surat penugasan.",
                      style: TextStyle(color: Colors.grey)),
                ...letters.map(
                  (e) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading:
                          const Icon(Icons.picture_as_pdf, color: Colors.red),
                      title: Text(
                        (e['assignmentType'] ?? 'Surat')
                            .toString()
                            .toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("No: ${e['letterNumber'] ?? '-'}"),
                          Text(
                              "Tanggal: ${e['letterDate']?.toString().split('T').first ?? '-'}"),
                        ],
                      ),
                      onTap: () async {
                        final urlStr = e['fileUrl'];
                        if (urlStr == null) return;

                        final uri = Uri.parse(urlStr);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        } else {
                          Get.snackbar(
                              'Error', 'Tidak dapat membuka tautan PDF.');
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Get.toNamed(
                        '/admin/assign-device/edit',
                        arguments: {'assignmentId': widget.assignmentId},
                      );

                      if (result != null &&
                          result is Map &&
                          result['updated'] == true) {
                        _refreshDetail();
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Assignment"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
