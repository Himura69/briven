import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/admin_nav_bar.dart';
import '../controllers/admin_devices_controller.dart';
import '../models/admin_device_model.dart';

class DeviceFormScreen extends StatefulWidget {
  final AdminDeviceModel? device;

  const DeviceFormScreen({super.key, this.device});

  @override
  State<DeviceFormScreen> createState() => _DeviceFormScreenState();
}

class _DeviceFormScreenState extends State<DeviceFormScreen> {
  final controller = Get.find<AdminDevicesController>();

  final _formKey = GlobalKey<FormState>();

  final brandController = TextEditingController();
  final brandNameController = TextEditingController();
  final serialController = TextEditingController();
  final assetCodeController = TextEditingController();
  final spec1Controller = TextEditingController();
  final spec2Controller = TextEditingController();
  final spec3Controller = TextEditingController();
  final spec4Controller = TextEditingController();
  final spec5Controller = TextEditingController();
  final devDateController = TextEditingController();

  final bribox = RxString('');
  final condition = RxString('');
  final status = RxString('');

  bool get isEditing => widget.device != null;

  @override
  void initState() {
    super.initState();
    controller.loadFormOptions();
    controller.loadValidationRules();

    if (isEditing) {
      brandController.text = widget.device!.brand;
      brandNameController.text = widget.device!.brandName;
      serialController.text = widget.device!.serialNumber;
      assetCodeController.text = widget.device!.assetCode;
      spec1Controller.text = widget.device!.spec1 ?? '';
      spec2Controller.text = widget.device!.spec2 ?? '';
      spec3Controller.text = widget.device!.spec3 ?? '';
      spec4Controller.text = widget.device!.spec4 ?? '';
      spec5Controller.text = widget.device!.spec5 ?? '';
      condition.value = widget.device!.condition;
      bribox.value = widget.device!.category;
      status.value =
          widget.device!.isAssigned ? "Digunakan" : "Tidak Digunakan";

      if (widget.device!.assignedDate != null) {
        devDateController.text = widget.device!.assignedDate!;
      }
    }
  }

  @override
  void dispose() {
    brandController.dispose();
    brandNameController.dispose();
    serialController.dispose();
    assetCodeController.dispose();
    spec1Controller.dispose();
    spec2Controller.dispose();
    spec3Controller.dispose();
    spec4Controller.dispose();
    spec5Controller.dispose();
    devDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(devDateController.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        devDateController.text = formatted;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "brand": brandController.text,
      "brand_name": brandNameController.text,
      "serial_number": serialController.text,
      "asset_code": assetCodeController.text,
      "bribox_id": bribox.value,
      "condition": condition.value,
      "status": status.value,
      "spec1": spec1Controller.text,
      "spec2": spec2Controller.text,
      "spec3": spec3Controller.text,
      "spec4": spec4Controller.text,
      "spec5": spec5Controller.text,
      "dev_date":
          devDateController.text.isNotEmpty ? devDateController.text : null,
    };

    bool success;
    if (isEditing) {
      success = await controller.updateDevice(widget.device!.deviceId, payload);
    } else {
      success = await controller.createDevice(payload);
    }

    if (success) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AdminNavBar(),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        final options = controller.formOptions;
        final rules = controller.validationRules;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Perangkat' : 'Tambah Perangkat',
                  style: AppStyles.title
                      .copyWith(fontSize: 22, color: Colors.black87),
                ),
                const SizedBox(height: 24),

                // Brand Dropdown
                DropdownButtonFormField<String>(
                  value: brandController.text.isNotEmpty
                      ? brandController.text
                      : null,
                  items: (options['brands'] as List<dynamic>? ?? [])
                      .map((item) => DropdownMenuItem<String>(
                            value: item['value'],
                            child: Text(item['value']),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Brand'),
                  onChanged: (val) {
                    if (val != null) brandController.text = val;
                  },
                  validator: (val) {
                    if ((rules['rules']?['brand'] ?? []).contains('required') &&
                        (val == null || val.isEmpty)) {
                      return rules['messages']?['brand.required'] ??
                          'Brand wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Brand Name Dropdown
                DropdownButtonFormField<String>(
                  value: brandNameController.text.isNotEmpty
                      ? brandNameController.text
                      : null,
                  items: (options['brandNames'] as List<dynamic>? ?? [])
                      .map((item) => DropdownMenuItem<String>(
                            value: item['value'],
                            child: Text(item['value']),
                          ))
                      .toList(),
                  decoration:
                      const InputDecoration(labelText: 'Brand Name / Model'),
                  onChanged: (val) {
                    if (val != null) brandNameController.text = val;
                  },
                  validator: (val) {
                    if ((rules['rules']?['brand_name'] ?? [])
                            .contains('required') &&
                        (val == null || val.isEmpty)) {
                      return rules['messages']?['brand_name.required'] ??
                          'Brand Name wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Serial Number
                TextFormField(
                  controller: serialController,
                  decoration: const InputDecoration(labelText: 'Serial Number'),
                  validator: (val) {
                    if ((rules['rules']?['serial_number'] ?? [])
                            .contains('required') &&
                        (val == null || val.isEmpty)) {
                      return rules['messages']?['serial_number.required'] ??
                          'Serial number wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Asset Code
                TextFormField(
                  controller: assetCodeController,
                  decoration: const InputDecoration(labelText: 'Asset Code'),
                  validator: (val) {
                    if ((rules['rules']?['asset_code'] ?? [])
                            .contains('required') &&
                        (val == null || val.isEmpty)) {
                      return rules['messages']?['asset_code.required'] ??
                          'Asset code wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Bribox Dropdown
                DropdownButtonFormField<String>(
                  value: bribox.value.isNotEmpty ? bribox.value : null,
                  items: (options['briboxes'] as List<dynamic>? ?? [])
                      .map((item) => DropdownMenuItem<String>(
                            value: item['value'],
                            child: Text(item['label']),
                          ))
                      .toList(),
                  decoration:
                      const InputDecoration(labelText: 'Kategori (Bribox)'),
                  onChanged: (val) => bribox.value = val ?? '',
                  validator: (val) {
                    if ((rules['rules']?['bribox_id'] ?? [])
                            .contains('required') &&
                        (val == null || val.isEmpty)) {
                      return rules['messages']?['bribox_id.required'] ??
                          'Kategori wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Condition Dropdown
                DropdownButtonFormField<String>(
                  value: condition.value.isNotEmpty ? condition.value : null,
                  items: (options['conditions'] as List<dynamic>? ?? [])
                      .map((item) => DropdownMenuItem<String>(
                            value: item['value'],
                            child: Text(item['value']),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Kondisi'),
                  onChanged: (val) => condition.value = val ?? '',
                ),
                const SizedBox(height: 16),

                // Status Dropdown
                DropdownButtonFormField<String>(
                  value: status.value.isNotEmpty ? status.value : null,
                  items: (options['statuses'] as List<dynamic>? ?? [])
                      .map((item) => DropdownMenuItem<String>(
                            value: item['value'],
                            child: Text(item['value']),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Status'),
                  onChanged: (val) => status.value = val ?? '',
                ),
                const SizedBox(height: 16),

                // Development Date (Date Picker)
                TextFormField(
                  controller: devDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Pembelian/Produksi',
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),

                // Spesifikasi Tambahan
                TextFormField(
                    controller: spec1Controller,
                    decoration:
                        const InputDecoration(labelText: 'Spesifikasi 1')),
                const SizedBox(height: 8),
                TextFormField(
                    controller: spec2Controller,
                    decoration:
                        const InputDecoration(labelText: 'Spesifikasi 2')),
                const SizedBox(height: 8),
                TextFormField(
                    controller: spec3Controller,
                    decoration:
                        const InputDecoration(labelText: 'Spesifikasi 3')),
                const SizedBox(height: 8),
                TextFormField(
                    controller: spec4Controller,
                    decoration:
                        const InputDecoration(labelText: 'Spesifikasi 4')),
                const SizedBox(height: 8),
                TextFormField(
                    controller: spec5Controller,
                    decoration:
                        const InputDecoration(labelText: 'Spesifikasi 5')),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      isEditing ? 'Simpan Perubahan' : 'Tambah Perangkat',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
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
