import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../services/api_service.dart';

class AppColors {
  static const Color primary = Color(0xFF1976D2);
}

class ReturnDeviceFormScreen extends StatefulWidget {
  final int assignmentId;

  const ReturnDeviceFormScreen({Key? key, required this.assignmentId})
      : super(key: key);

  @override
  State<ReturnDeviceFormScreen> createState() => _ReturnDeviceFormScreenState();
}

class _ReturnDeviceFormScreenState extends State<ReturnDeviceFormScreen> {
  final api = Get.find<ApiService>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController letterNumberController = TextEditingController();
  DateTime? selectedDate;
  File? letterFile;
  bool isSubmitting = false;

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        letterFile = File(result.files.single.path!);
      });
    }
  }

  void pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void submit() async {
    if (!_formKey.currentState!.validate() ||
        letterFile == null ||
        selectedDate == null) {
      Get.snackbar("Error", "Lengkapi semua data dan upload file");
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await api.returnDeviceAssignment(
        assignmentId: widget.assignmentId,
        fields: {
          'letter_number': letterNumberController.text,
          'letter_date': DateFormat('yyyy-MM-dd').format(selectedDate!),
        },
        letterFile: letterFile!,
      );
      Get.back(result: true);
      Get.snackbar("Sukses", "Device berhasil dikembalikan");
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Form Pengembalian Device',
          style: TextStyle(color: AppColors.primary),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.primary),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: letterNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Surat',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.confirmation_number),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: pickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Surat',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.date_range),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          selectedDate == null
                              ? 'Pilih tanggal'
                              : DateFormat('dd MMMM yyyy', 'id')
                                  .format(selectedDate!),
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedDate == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: pickFile,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload Surat Pengembalian (PDF)'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                  if (letterFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "File dipilih: ${letterFile!.path.split('/').last}",
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isSubmitting ? null : submit,
                      icon: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : const Icon(Icons.send, color: AppColors.primary),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          isSubmitting ? 'Mengirim...' : 'Submit Pengembalian',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
