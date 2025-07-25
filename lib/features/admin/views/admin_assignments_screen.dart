import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../admin/controllers/admin_assignment_controller.dart';
import '../models/admin_assignment_model.dart';
import 'admin_assignment_form_screen.dart';

class AdminAssignmentsScreen extends StatelessWidget {
  const AdminAssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminAssignmentsController());
    controller.fetchAssignments();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const AdminAssignmentFormScreen());
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Assignment',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: LoadingIndicator());
          }
          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Text(controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red)),
            );
          }
          if (controller.assignments.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada assignment.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.fetchAssignments,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.assignments.length,
              itemBuilder: (context, index) {
                final AdminAssignmentModel assignment =
                    controller.assignments[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.devices_other,
                        color: Colors.blueAccent),
                    title: Text(
                      '${assignment.brand} ${assignment.brandName}',
                      style: AppStyles.title.copyWith(fontSize: 16),
                    ),
                    subtitle: Text(
                      'Asset: ${assignment.assetCode} • User: ${assignment.assignedTo}\n'
                      'Cabang: ${assignment.unitName}',
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        Get.to(() =>
                            AdminAssignmentFormScreen(assignment: assignment));
                      },
                    ),
                    onTap: () {
                      Get.snackbar(
                        "Info",
                        "Klik assignment ID: ${assignment.assignmentId}",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
