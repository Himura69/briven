import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../admin/controllers/admin_assignment_wizard_controller.dart';
import '../../../../../core/widgets/loading_indicator.dart';
import '../../../../admin/models/assignment_form_options_model.dart';

class StepSelectDevice extends StatelessWidget {
  final controller = Get.find<AdminAssignmentWizardController>();

  StepSelectDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.deviceOptions.isEmpty) {
        return const Text("Tidak ada perangkat tersedia.");
      }

      return DropdownButtonFormField<FormOption>(
        value: controller.selectedDevice.value,
        items: controller.deviceOptions
            .map(
              (device) => DropdownMenuItem<FormOption>(
                value: device,
                child: Text(device.label),
              ),
            )
            .toList(),
        onChanged: (value) {
          controller.selectedDevice.value = value;
        },
        decoration: const InputDecoration(
          labelText: "Pilih Perangkat",
          border: OutlineInputBorder(),
        ),
      );
    });
  }
}
