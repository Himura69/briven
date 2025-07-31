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

    if (args is Map && args.containsKey('assignmentId')) {
      final int id = args['assignmentId'];
      print('🟠 [AssignDeviceWizardScreen] Mode EDIT - assignmentId: $id');
      controller.assignmentId = id;
      controller.fetchAssignmentDetail();
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

      final isEdit = controller.isEditMode;
      final currentStep = controller.currentStep.value;
      final totalSteps = isEdit ? 4 : 3;

      final steps = <Step>[
        Step(
          title: Row(
            children: const [
              Icon(Icons.devices_outlined, size: 20),
              SizedBox(width: 8),
              Text("Pilih Perangkat"),
            ],
          ),
          content: StepSelectDevice(),
          isActive: currentStep >= 0,
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Row(
            children: const [
              Icon(Icons.person_outline, size: 20),
              SizedBox(width: 8),
              Text("Pilih Pengguna"),
            ],
          ),
          content: StepSelectUser(),
          isActive: currentStep >= 1,
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        if (isEdit)
          Step(
            title: Row(
              children: const [
                Icon(Icons.apartment_outlined, size: 20),
                SizedBox(width: 8),
                Text("Unit / Branch"),
              ],
            ),
            content: StepBranchSummary(),
            isActive: currentStep >= 2,
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
        Step(
          title: Row(
            children: const [
              Icon(Icons.check_circle_outline, size: 20),
              SizedBox(width: 8),
              Text("Konfirmasi"),
            ],
          ),
          content: StepConfirmation(),
          isActive: currentStep >= (isEdit ? 3 : 2),
          state: currentStep == (totalSteps - 1)
              ? StepState.editing
              : StepState.indexed,
        ),
      ];

      return Scaffold(
        appBar: AppBar(
          title: Text(
            isEdit ? 'Edit Device Assignment' : 'Assign Device',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: isEdit ? Colors.orange.shade700 : Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Stepper(
          type: StepperType.vertical,
          currentStep: currentStep,
          onStepContinue: () {
            if (currentStep < totalSteps - 1) {
              controller.nextStep();
            } else {
              controller.handleSubmit();
            }
          },
          onStepCancel: () {
            if (currentStep > 0) {
              controller.previousStep();
            } else {
              Get.back();
            }
          },
          steps: steps,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (currentStep > 0)
                    TextButton.icon(
                      onPressed: details.onStepCancel,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Kembali"),
                    ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: details.onStepContinue,
                    icon: Icon(
                      currentStep == totalSteps - 1
                          ? Icons.send
                          : Icons.arrow_forward,
                    ),
                    label: Text(
                      currentStep == totalSteps - 1
                          ? (isEdit ? 'Update Assignment' : 'Assign Device')
                          : 'Lanjut',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentStep == totalSteps - 1
                          ? (isEdit ? Colors.orange : Colors.blue)
                          : null,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
