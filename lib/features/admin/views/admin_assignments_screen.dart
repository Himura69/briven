import 'package:briven/features/admin/views/admin_assignment_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../admin/controllers/admin_assignment_controller.dart';
import '../models/admin_assignment_model.dart';

class AdminAssignmentsScreen extends StatelessWidget {
  const AdminAssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminAssignmentsController());
    controller.fetchAssignments();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            // Baris atas: Search + Filter ActiveOnly
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) {
                      controller.searchQuery.value = val;
                      controller.fetchAssignments();
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari assignment...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Obx(() => IconButton(
                      tooltip: controller.activeOnly.value
                          ? 'Tampilkan semua'
                          : 'Hanya aktif',
                      icon: Icon(
                        controller.activeOnly.value
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: controller.activeOnly.value
                            ? Colors.green
                            : Colors.grey,
                      ),
                      onPressed: controller.toggleActiveOnly,
                    )),
              ],
            ),
            const SizedBox(height: 16),

            // List dengan Pull-to-Refresh
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: LoadingIndicator());
                }
                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                      child: Text(controller.errorMessage.value,
                          style: const TextStyle(color: Colors.red)));
                }
                if (controller.assignments.isEmpty) {
                  return const Center(
                      child: Text('Belum ada assignment.',
                          style:
                              TextStyle(fontSize: 16, color: Colors.black54)));
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshAssignments,
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
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                assignment.status ?? 'Tidak Ada',
                                style: TextStyle(
                                  color:
                                      (assignment.status ?? '').toLowerCase() ==
                                              'digunakan'
                                          ? Colors.green
                                          : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                assignment.assignedDate,
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.black54),
                              ),
                            ],
                          ),
                          onTap: () {
                            Get.to(
                                () => AdminAssignmentDetailScreen(
                                    assignmentId: assignment.assignmentId),
                                transition: Transition.rightToLeft);
                          },
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
