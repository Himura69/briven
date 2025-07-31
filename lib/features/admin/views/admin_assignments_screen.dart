import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import 'assignment_wizard/assign_device_wizard_screen.dart';
import '../../admin/views/assignment_wizard/assignment_detail_screen.dart'; // Pastikan ini ada

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Device Assignments")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadAssignments,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  final item = assignments[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['assetCode'] ?? 'Kode Aset Tidak Diketahui',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildRow("Pengguna", item['assignedTo']),
                          _buildRow("Unit", item['unitName']),
                          _buildRow("Status", item['status']),
                          _buildRow("Tanggal", item['assignedDate']),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                tooltip: "Lihat Detail",
                                onPressed: () =>
                                    goToDetail(item['assignmentId']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: "Edit Assignment",
                                onPressed: () =>
                                    goToEditAssignment(item['assignmentId']),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: goToAddAssignment,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Assignment"),
      ),
    );
  }

  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(value ?? '-', overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
