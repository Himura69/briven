import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../admin/controllers/admin_assignment_controller.dart';
import '../models/admin_assignment_model.dart';

class AdminAssignmentFormScreen extends StatefulWidget {
  final AdminAssignmentModel? assignment;

  const AdminAssignmentFormScreen({super.key, this.assignment});

  @override
  State<AdminAssignmentFormScreen> createState() =>
      _AdminAssignmentFormScreenState();
}

class _AdminAssignmentFormScreenState extends State<AdminAssignmentFormScreen> {
  final controller = Get.find<AdminAssignmentsController>();
  final _formKey = GlobalKey<FormState>();

  final deviceId = RxnInt();
  final userId = RxnInt();
  final branchId = RxnInt();
  final assignedDateController = TextEditingController();
  final returnedDateController = TextEditingController();
  final notesController = TextEditingController();

  final letterNumberController = TextEditingController();
  final letterDateController = TextEditingController();
  File? selectedLetterFile;

  bool get isEditing => widget.assignment != null;

  @override
  void initState() {
    super.initState();
    controller.loadFormOptions();
    controller.loadValidationRules();

    if (isEditing) {
      final assignment = widget.assignment!;
      assignedDateController.text = assignment.assignedDate;
      notesController.text = '';
    }
  }

  Future<void> _pickDate(TextEditingController target) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(target.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      target.text = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {});
    }
  }

  Future<void> _pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedLetterFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedLetterFile == null) {
      Get.snackbar("Error", "File surat (PDF) wajib dipilih",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final payload = {
      "device_id": deviceId.value,
      "user_id": userId.value,
      "branch_id": branchId.value,
      "assigned_date": assignedDateController.text,
      "returned_date": returnedDateController.text.isNotEmpty
          ? returnedDateController.text
          : null,
      "notes": notesController.text,
      "letter_number": letterNumberController.text,
      "letter_date": letterDateController.text,
      "letter_file": selectedLetterFile, // Akan dikirim via multipart
    };

    try {
      if (isEditing) {
        await controller.updateAssignmentMultipart(
            widget.assignment!.assignmentId, payload);
        Get.snackbar("Sukses", "Assignment berhasil diperbarui",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      } else {
        await controller.createAssignmentMultipart(payload);
        Get.snackbar("Sukses", "Assignment berhasil ditambahkan",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      }

      Get.back();
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Assignment' : 'Tambah Assignment'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: const Color(0xFFF4F6F8),
      body: Obx(() {
        if (controller.isFormLoading.value) {
          return const Center(child: LoadingIndicator());
        }
        if (controller.formError.isNotEmpty) {
          return Center(
            child: Text(controller.formError.value,
                style: const TextStyle(color: Colors.red)),
          );
        }

        final options = controller.formOptions;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Dropdown Perangkat
                DropdownButtonFormField<int>(
                  value: deviceId.value,
                  items: (options['devices'] as List<dynamic>? ?? [])
                      .map((item) => DropdownMenuItem<int>(
                            value: item['device_id'],
                            child: Text(item['label']),
                          ))
                      .toList(),
                  onChanged: (val) => deviceId.value = val,
                  decoration: const InputDecoration(
                    labelText: 'Pilih Perangkat',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null ? 'Perangkat wajib dipilih' : null,
                ),
                const SizedBox(height: 16),

                // Dropdown User
                DropdownButtonFormField<int>(
                  value: userId.value,
                  items: (options['users'] as List<dynamic>? ?? [])
                      .map((item) => DropdownMenuItem<int>(
                            value: item['user_id'],
                            child: Text(item['label']),
                          ))
                      .toList(),
                  onChanged: (val) => userId.value = val,
                  decoration: const InputDecoration(
                    labelText: 'Pilih User',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val == null ? 'User wajib dipilih' : null,
                ),
                const SizedBox(height: 16),

                // Dropdown Cabang
                DropdownButtonFormField<int>(
                  value: branchId.value,
                  items: (options['branches'] as List<dynamic>? ?? [])
                      .map((item) => DropdownMenuItem<int>(
                            value: item['branch_id'],
                            child: Text(item['label']),
                          ))
                      .toList(),
                  onChanged: (val) => branchId.value = val,
                  decoration: const InputDecoration(
                    labelText: 'Pilih Cabang',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null ? 'Cabang wajib dipilih' : null,
                ),
                const SizedBox(height: 16),

                // Tanggal Penugasan
                TextFormField(
                  controller: assignedDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Penugasan',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(assignedDateController),
                  validator: (val) => (val == null || val.isEmpty)
                      ? 'Tanggal wajib diisi'
                      : null,
                ),
                const SizedBox(height: 16),

                // Tanggal Pengembalian (Opsional)
                TextFormField(
                  controller: returnedDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Pengembalian (Opsional)',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(returnedDateController),
                ),
                const SizedBox(height: 16),

                // Nomor Surat
                TextFormField(
                  controller: letterNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Surat Penugasan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => (val == null || val.isEmpty)
                      ? 'Nomor surat wajib diisi'
                      : null,
                ),
                const SizedBox(height: 16),

                // Tanggal Surat
                TextFormField(
                  controller: letterDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Surat Penugasan',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(letterDateController),
                  validator: (val) => (val == null || val.isEmpty)
                      ? 'Tanggal surat wajib diisi'
                      : null,
                ),
                const SizedBox(height: 16),

                // Upload File
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedLetterFile?.path.split('/').last ??
                            'Belum ada file dipilih',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _pickPdfFile,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Pilih PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Catatan
                TextFormField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Catatan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.save),
                  label: Text(
                      isEditing ? 'Simpan Perubahan' : 'Tambah Assignment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
