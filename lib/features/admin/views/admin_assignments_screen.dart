import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import 'assignment_wizard/assign_device_wizard_screen.dart';

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
    if (result != null) {
      loadAssignments();
    }
  }

  void goToEditAssignment(int assignmentId) async {
    try {
      final detail = await api.getDeviceAssignmentDetail(assignmentId);
      final result = await Get.to(
        () => AssignDeviceWizardScreen(),
        arguments: detail,
      );
      if (result != null) {
        loadAssignments(); // Refresh list if updated
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil detail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: ListTile(
                      title: Text(item['assetCode'] ?? 'Unknown'),
                      subtitle: Text(
                        '${item['assignedTo']} - ${item['status'] ?? ''}',
                      ),
                      trailing: Text(
                        item['assignedDate'] ?? '',
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () => goToEditAssignment(item['assignmentId']),
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
}
