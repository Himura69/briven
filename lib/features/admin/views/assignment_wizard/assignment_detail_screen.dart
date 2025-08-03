import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../services/api_service.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final int assignmentId;

  const AssignmentDetailScreen({super.key, required this.assignmentId});

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  static const Color primaryColor = Color(0xFF1976D2);

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

  Future<bool> _checkStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 30) {
        final status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          final result = await Permission.manageExternalStorage.request();
          return result.isGranted;
        }
        return true;
      } else {
        final status = await Permission.storage.status;
        if (!status.isGranted) {
          final result = await Permission.storage.request();
          return result.isGranted;
        }
        return true;
      }
    }
    return true;
  }

  Future<void> _downloadAndOpenPdf(String url, String fileName) async {
    try {
      final hasPermission = await _checkStoragePermission();
      if (!hasPermission) {
        Get.snackbar('Izin Ditolak', 'Akses penyimpanan diperlukan.');
        return;
      }

      final downloadDir = Directory('/storage/emulated/0/Download');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final savePath = '${downloadDir.path}/$fileName';

      final dio = Dio();
      await dio.download(url, savePath);
      await OpenFile.open(savePath);
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal mengunduh file: $e');
    }
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
            appBar: AppBar(
              title: Text(
                "Detail Assignment",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: primaryColor,
            ),
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
          appBar: AppBar(
            title: Text(
              "Detail Assignment",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: primaryColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
                Text(
                  "📄 Surat Penugasan",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                if (letters.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Tidak ada surat penugasan.",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ...letters.map(
                  (e) => Card(
                    margin: const EdgeInsets.only(top: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      leading:
                          const Icon(Icons.picture_as_pdf, color: Colors.red),
                      title: Text(
                        (e['assignmentType'] ?? 'Surat')
                            .toString()
                            .toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            "No: ${e['letterNumber'] ?? '-'}",
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                          Text(
                            "Tanggal: ${e['letterDate']?.toString().split('T').first ?? '-'}",
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ],
                      ),
                      onTap: () async {
                        final urlStr = e['fileUrl'];
                        if (urlStr == null) return;

                        final uri = Uri.parse(urlStr);
                        final fileName = urlStr.split('/').last;
                        await _downloadAndOpenPdf(uri.toString(), fileName);
                      },
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
