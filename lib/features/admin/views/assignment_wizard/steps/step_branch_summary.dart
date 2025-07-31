import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../admin/controllers/admin_assignment_wizard_controller.dart';

class StepBranchSummary extends StatelessWidget {
  final controller = Get.find<AdminAssignmentWizardController>();

  StepBranchSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.selectedUser.value;
      final branch = controller.selectedBranch.value;

      if (user == null) {
        return const Text("Pengguna belum dipilih.");
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryItem("Pengguna", user.label),
          const SizedBox(height: 12),
          _buildSummaryItem("Unit / Branch", branch?.label ?? '-'),
        ],
      );
    });
  }

  Widget _buildSummaryItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(value, style: const TextStyle(fontSize: 14)),
        )
      ],
    );
  }
}
