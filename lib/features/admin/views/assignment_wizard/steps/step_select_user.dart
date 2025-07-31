import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../admin/controllers/admin_assignment_wizard_controller.dart';
import '../../../../admin/models/assignment_form_options_model.dart';

class StepSelectUser extends StatelessWidget {
  final controller = Get.find<AdminAssignmentWizardController>();

  StepSelectUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedUser.value;

      if (controller.userOptions.isEmpty) {
        return const Text("Tidak ada pengguna tersedia.");
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _showSearchUserDialog(context),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: "Pilih Pengguna",
                border: OutlineInputBorder(),
              ),
              child: Text(
                selected?.label ?? 'Pilih Pengguna',
                style: TextStyle(
                  color: selected != null ? Colors.black87 : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  void _showSearchUserDialog(BuildContext context) {
    final searchController = TextEditingController();
    List<FormOption> filtered = List.from(controller.userOptions);

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            void filter(String query) {
              setState(() {
                filtered = controller.userOptions
                    .where((item) =>
                        item.label.toLowerCase().contains(query.toLowerCase()))
                    .toList();
              });
            }

            return AlertDialog(
              title: const Text("Cari Pengguna"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: filter,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Ketik nama pengguna...',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 300,
                    width: double.maxFinite,
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, index) {
                        final item = filtered[index];
                        return ListTile(
                          title: Text(item.label),
                          onTap: () {
                            controller.selectedUser.value = item;

                            // Auto-set Branch
                            final userBranch =
                                controller.branchOptions.firstWhereOrNull(
                              (b) => item.label.contains(b.label),
                            );
                            controller.selectedBranch.value = userBranch;

                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
