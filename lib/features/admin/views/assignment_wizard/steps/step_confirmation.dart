// FILE 1: StepConfirmation
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../admin/controllers/admin_assignment_wizard_controller.dart';

class StepConfirmation extends StatefulWidget {
  const StepConfirmation({super.key});

  @override
  State<StepConfirmation> createState() => _StepConfirmationState();
}

class _StepConfirmationState extends State<StepConfirmation> {
  final controller = Get.find<AdminAssignmentWizardController>();
  late final TextEditingController notesController;
  late final TextEditingController letterNumberController;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController(text: controller.notes.value);
    letterNumberController =
        TextEditingController(text: controller.letterNumber.value);
  }

  @override
  void dispose() {
    notesController.dispose();
    letterNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateField(
              label: 'Tanggal Penugasan',
              selectedDate: controller.assignedDate.value,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: controller.assignedDate.value ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) controller.assignedDate.value = picked;
              },
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Catatan (opsional)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => controller.notes.value = val,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nomor Surat Penugasan',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: letterNumberController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => controller.letterNumber.value = val,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDateField(
              label: 'Tanggal Surat Penugasan',
              selectedDate: controller.letterDate.value,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: controller.letterDate.value ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) controller.letterDate.value = picked;
              },
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );

                if (result != null && result.files.single.path != null) {
                  controller.letterFile.value = File(result.files.single.path!);
                }
              },
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload File Surat (PDF)"),
            ),
            if (controller.letterFile.value != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'File dipilih: ${controller.letterFile.value!.path.split('/').last}',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    final text = selectedDate != null
        ? DateFormat('dd MMMM yyyy').format(selectedDate)
        : 'Pilih tanggal';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            child: Text(text),
          ),
        ),
      ],
    );
  }
}
