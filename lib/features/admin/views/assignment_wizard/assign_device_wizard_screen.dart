import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../admin/controllers/admin_assignment_wizard_controller.dart';
import 'steps/step_select_device.dart';
import 'steps/step_select_user.dart';
import 'steps/step_branch_summary.dart';
import 'steps/step_confirmation.dart';

const Color primary = Color(0xFF1976D2);
const Color stepInactiveColor = Colors.black87;

class AssignDeviceWizardScreen extends StatelessWidget {
  AssignDeviceWizardScreen({super.key}) {
    Get.put(AdminAssignmentWizardController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminAssignmentWizardController>();

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
          title: _buildStepTitle(
              "Pilih Perangkat", Icons.devices_outlined, currentStep == 0),
          content: StepSelectDevice(),
          isActive: currentStep >= 0,
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: _buildStepTitle(
              "Pilih Pengguna", Icons.person_outline, currentStep == 1),
          content: StepSelectUser(),
          isActive: currentStep >= 1,
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        if (isEdit)
          Step(
            title: _buildStepTitle(
                "Unit / Branch", Icons.apartment_outlined, currentStep == 2),
            content: StepBranchSummary(),
            isActive: currentStep >= 2,
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
        Step(
          title: _buildStepTitle("Konfirmasi", Icons.check_circle_outline,
              currentStep == (isEdit ? 3 : 2)),
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
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: primary,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primary,
              onPrimary: Colors.white,
              onSurface: stepInactiveColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primary,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          child: Stepper(
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
                  padding:
                      const EdgeInsets.only(top: 20.0, right: 12, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (currentStep > 0)
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text("Kembali"),
                        ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 38,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          onPressed: details.onStepContinue,
                          child: Text(
                            currentStep == totalSteps - 1
                                ? (isEdit ? 'Update' : 'Assign')
                                : 'Lanjut',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      );
    });
  }

  Widget _buildStepTitle(String text, IconData icon, bool isActive) {
    final color = isActive ? primary : stepInactiveColor;

    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
