import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

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

        return Scaffold(
          appBar: AppBar(title: const Text("Detail Assignment")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildRow("Perangkat", deviceInfo),
                _buildRow("Pengguna", user),
                _buildRow("Unit", unit),
                _buildRow("Tanggal Assign", assignedDate),
                _buildRow("Catatan", notes),
                const SizedBox(height: 20),
                if (data['assignmentLetters'] != null &&
                    data['assignmentLetters'] is List &&
                    data['assignmentLetters'].isNotEmpty) ...[
                  const Text("Surat Penugasan:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...List<Widget>.from(
                    (data['assignmentLetters'] as List).map(
                      (e) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(
                            e['assignmentType']?.toString().toUpperCase() ??
                                'Surat',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("No: \${e['letterNumber'] ?? '-'}"),
                              Text(
                                  "Tanggal: \${e['letterDate']?.toString().split('T').first ?? '-'}"),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.picture_as_pdf),
                            onPressed: () async {
                              final urlStr = e['fileUrl'];
                              if (urlStr == null) return;

                              final uri = Uri.parse(urlStr);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                Get.snackbar(
                                    'Error', 'Tidak dapat membuka tautan PDF.');
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Get.toNamed(
                        '/admin/assign-device/edit',
                        arguments: {
                          'assignmentId': widget.assignmentId,
                        });

                    if (result != null &&
                        result is Map &&
                        result['updated'] == true) {
                      _refreshDetail();
                    }
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Assignment"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
