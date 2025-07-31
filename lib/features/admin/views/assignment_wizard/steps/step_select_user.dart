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
      if (controller.userOptions.isEmpty) {
        return const Text("Tidak ada pengguna tersedia.");
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<FormOption>(
            value: controller.selectedUser.value,
            items: controller.userOptions
                .map(
                  (user) => DropdownMenuItem<FormOption>(
                    value: user,
                    child: Text(user.label),
                  ),
                )
                .toList(),
            onChanged: (value) {
              controller.selectedUser.value = value;

              // Coba auto-set branch berdasarkan label user (opsional)
              final userBranch = controller.branchOptions.firstWhereOrNull(
                (b) => value?.label.contains(b.label) == true,
              );
              controller.selectedBranch.value = userBranch;
            },
            decoration: const InputDecoration(
              labelText: "Pilih Pengguna",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          if (controller.selectedBranch.value != null)
            Text(
              "Unit: ${controller.selectedBranch.value?.label}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
        ],
      );
    });
  }
}
