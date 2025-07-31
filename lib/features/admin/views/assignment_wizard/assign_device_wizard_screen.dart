import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../admin/controllers/admin_assignment_wizard_controller.dart';
import 'steps/step_select_device.dart';
import 'steps/step_select_user.dart';
import 'steps/step_branch_summary.dart';
import 'steps/step_confirmation.dart';

class AssignDeviceWizardScreen extends StatelessWidget {
  final controller = Get.put(AdminAssignmentWizardController());

  AssignDeviceWizardScreen({super.key}) {
    final args = Get.arguments;
    print('🧭 [AssignDeviceWizardScreen] Get.arguments: $args');

    if (args != null && args is Map && args.containsKey('assignmentId')) {
      final int id = args['assignmentId'];
      print('🟠 [AssignDeviceWizardScreen] Mode EDIT - assignmentId: $id');
      controller.assignmentId = id;
      controller.fetchAssignmentDetail(); // 🔑 PANGGIL API DETAIL
    } else {
      print('🟢 [AssignDeviceWizardScreen] Mode CREATE');
      controller.fetchFormOptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(child: LoadingIndicator()),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(
            controller.isEditMode ? 'Edit Device Assignment' : 'Assign Device',
          ),
          backgroundColor: controller.isEditMode ? Colors.orange : Colors.blue,
        ),
        body: Stepper(
          type: StepperType.vertical,
          currentStep: controller.currentStep.value,
          onStepContinue: () {
            if (controller.currentStep.value < 3) {
              controller.nextStep();
            } else {
              controller.handleSubmit();
            }
          },
          onStepCancel: () {
            if (controller.currentStep.value > 0) {
              controller.previousStep();
            } else {
              Get.back();
            }
          },
          steps: [
            Step(
              title: Text(controller.isEditMode
                  ? "Perangkat yang Dipinjam"
                  : "Pilih Perangkat"),
              content: StepSelectDevice(),
              isActive: controller.currentStep.value >= 0,
              state: controller.currentStep.value > 0
                  ? StepState.complete
                  : StepState.indexed,
            ),
            Step(
              title: Text(controller.isEditMode
                  ? "Pengguna yang Bertanggung Jawab"
                  : "Pilih Pengguna"),
              content: StepSelectUser(),
              isActive: controller.currentStep.value >= 1,
              state: controller.currentStep.value > 1
                  ? StepState.complete
                  : StepState.indexed,
            ),
            Step(
              title: const Text("Unit & Supervisor"),
              content: StepBranchSummary(),
              isActive: controller.currentStep.value >= 2,
              state: controller.currentStep.value > 2
                  ? StepState.complete
                  : StepState.indexed,
            ),
            Step(
              title: const Text("Konfirmasi"),
              content: StepConfirmation(),
              isActive: controller.currentStep.value >= 3,
              state: controller.currentStep.value == 3
                  ? StepState.editing
                  : StepState.indexed,
            ),
          ],
          controlsBuilder: (context, details) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (controller.currentStep.value > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text("Kembali"),
                  ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(
                    controller.currentStep.value == 3
                        ? (controller.isEditMode
                            ? 'Update Assignment'
                            : 'Assign Device')
                        : 'Lanjut',
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
