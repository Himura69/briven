// Pastikan Anda sudah menambahkan dependensi `intl` di pubspec.yaml Anda
// dependencies:
//   flutter:
//     sdk: flutter
//   get: ^4.6.5
//   intl: ^0.18.1  <-- Tambahkan ini
//
// Kemudian jalankan `flutter pub get` di terminal Anda.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import library intl
import '../../../services/api_service.dart';
import 'assignment_wizard/assign_device_wizard_screen.dart';
import '../../admin/views/assignment_wizard/assignment_detail_screen.dart';

// Definisi warna yang diambil dari gambar
const Color primaryBlue = Color(0xFF1E88E5);
const Color secondaryTextGray = Color(0xFF5A5A5A);
const Color cardBackground = Color(0xFFF8F9FB);
const Color buttonBlue = Color(0xFF2196F3);
const Color buttonGreen = Colors.green;
const Color buttonRed = Colors.redAccent;

class AdminAssignmentsScreen extends StatefulWidget {
  const AdminAssignmentsScreen({super.key});

  @override
  State<AdminAssignmentsScreen> createState() => _AdminAssignmentsScreenState();
}

class _AdminAssignmentsScreenState extends State<AdminAssignmentsScreen> {
  final api = Get.find<ApiService>();
  List<dynamic> assignments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    setState(() => isLoading = true);
    try {
      final res = await api.get('/admin/device-assignments');
      assignments = res.body['data'] ?? [];
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void goToAddAssignment() async {
    final result = await Get.to(() => AssignDeviceWizardScreen());
    if (result == true) loadAssignments();
  }

  void goToEditAssignment(int assignmentId) async {
    final detail = await api.getDeviceAssignmentDetail(assignmentId);
    final result = await Get.to(
      () => AssignDeviceWizardScreen(),
      arguments: detail,
    );
    if (result == true) loadAssignments();
  }

  void goToDetail(int assignmentId) {
    Get.to(() => AssignmentDetailScreen(assignmentId: assignmentId));
  }

  // Fungsi baru untuk memformat tanggal
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return '-';
    }
    try {
      // Coba parsing tanggal. Jika format dari API konsisten (misalnya ISO 8601),
      // maka DateTime.parse() sudah cukup.
      // Jika formatnya bervariasi, Anda mungkin perlu logika parsing yang lebih canggih.
      final date = DateTime.parse(dateString);
      // Menggunakan Intl untuk format tanggal ke bahasa Indonesia
      final formatter = DateFormat('dd MMMM yyyy', 'id');
      return formatter.format(date);
    } catch (e) {
      // Jika parsing gagal, kembalikan string asli atau pesan error
      print("Error parsing date: $e");
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadAssignments,
              child: Column(
                children: [
                  _buildTotalDevicesHeader(assignments.length),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 13),
                      itemCount: assignments.length,
                      itemBuilder: (context, index) {
                        final item = assignments[index];
                        Color statusColor = secondaryTextGray;
                        if (item['status'] == 'Digunakan' ||
                            item['status'] == 'Dipinjam') {
                          statusColor = buttonGreen;
                        } else if (item['status'] == 'Selesai') {
                          statusColor = primaryBlue;
                        } else if (item['status'] == 'Rusak') {
                          statusColor = buttonRed;
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: cardBackground,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: primaryBlue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.assignment,
                                          color: primaryBlue),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['assetCode'] ??
                                                'Kode Aset Tidak Diketahui',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            item['assignedTo'] ??
                                                'Pengguna Tidak Diketahui',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: secondaryTextGray,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _buildStatusChip(
                                        item['status'] ?? '-', statusColor),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Divider(height: 1, color: Colors.grey),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                    icon: Icons.business,
                                    label: "Unit",
                                    value: item['unitName'],
                                    color: secondaryTextGray),
                                _buildInfoRow(
                                    icon: Icons.calendar_today,
                                    label: "Tanggal",
                                    // Menggunakan fungsi _formatDate
                                    value: _formatDate(item['assignedDate']),
                                    color: secondaryTextGray),
                                _buildInfoRow(
                                    icon: Icons.timer,
                                    label: "Durasi",
                                    value: '2 Hari',
                                    color: secondaryTextGray),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () =>
                                          goToDetail(item['assignmentId']),
                                      icon: const Icon(Icons.visibility,
                                          size: 18, color: buttonBlue),
                                      label: const Text("Detail",
                                          style: TextStyle(color: buttonBlue)),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      onPressed: () => goToEditAssignment(
                                          item['assignmentId']),
                                      icon: const Icon(Icons.edit,
                                          size: 18, color: buttonGreen),
                                      label: const Text("Edit",
                                          style: TextStyle(color: buttonGreen)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: goToAddAssignment,
        backgroundColor: primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Tambah Assignment",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTotalDevicesHeader(int total) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Total: $total',
              style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String? value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: TextStyle(color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
