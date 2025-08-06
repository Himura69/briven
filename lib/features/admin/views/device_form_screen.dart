import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_devices_controller.dart';
import '../models/admin_device_model.dart';

class DeviceFormScreen extends StatefulWidget {
  final AdminDeviceModel? device;
  final int? deviceId;
  const DeviceFormScreen({super.key, this.device, this.deviceId});

  @override
  State<DeviceFormScreen> createState() => _DeviceFormScreenState();
}

class _DeviceFormScreenState extends State<DeviceFormScreen> {
  final controller = Get.find<AdminDevicesController>();
  final _formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final deviceDetail = Rxn<AdminDeviceModel>();
  final errorMessage = ''.obs;

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

  final briboxId = RxString('');
  final briboxLabel = RxString('');
  final condition = RxString('');
  final status = RxString('');

  bool get isEditing => widget.deviceId != null;

  final TextEditingController _briboxSearchController = TextEditingController();
  final RxList<Map<String, dynamic>> _filteredBriboxes =
      <Map<String, dynamic>>[].obs;

  final TextEditingController _brandSearchController = TextEditingController();
  final RxList<Map<String, dynamic>> _filteredBrands =
      <Map<String, dynamic>>[].obs;

  final TextEditingController _brandNameSearchController =
      TextEditingController();
  final RxList<Map<String, dynamic>> _filteredBrandNames =
      <Map<String, dynamic>>[].obs;

  Future<void> _loadDeviceDetail() async {
    if (!isEditing) return;
    try {
      isLoading.value = true;
      final AdminDeviceModel? data =
          await controller.fetchDeviceDetail(widget.deviceId!);
      deviceDetail.value = data;
      log('Fetched device detail: $data');

      // Populate form fields with fetched data
      brandController.text = data?.brand ?? '';
      brandNameController.text = data?.brandName ?? '';
      serialController.text = data?.serialNumber ?? '';
      assetCodeController.text = data?.assetCode ?? '';
      briboxId.value = data?.briboxId ?? '';
      spec1Controller.text = data?.spec1 ?? '';
      spec2Controller.text = data?.spec2 ?? '';
      spec3Controller.text = data?.spec3 ?? '';
      spec4Controller.text = data?.spec4 ?? '';
      spec5Controller.text = data?.spec5 ?? '';
      devDateController.text = data?.devDate ?? '';
      condition.value = data?.condition ?? '';
      status.value =
          (data?.isAssigned ?? false) ? "Digunakan" : "Tidak Digunakan";

      // Prefill dropdown kategori dengan ID
      final allBriboxes =
          (controller.formOptions['briboxes'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();
      final selectedBribox = allBriboxes.firstWhereOrNull(
        (item) => item['value'].toString() == data?.briboxId?.toString(),
      );
      if (selectedBribox != null) {
        briboxId.value = selectedBribox['value'].toString();
        briboxLabel.value = selectedBribox['label'] ?? '';
      } else {
        briboxId.value = '';
        briboxLabel.value = '';
      }

      // Show warning to reselect bribox category
    } catch (e) {
      errorMessage.value = 'Gagal memuat detail perangkat: $e';
      Get.snackbar(
        "Error",
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 5),
        icon: const Icon(Icons.error, color: Colors.white),
        isDismissible: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    controller.loadFormOptions().then((_) {
      _filteredBrands.value =
          (controller.formOptions['brands'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();
      _filteredBrandNames.value =
          (controller.formOptions['brandNames'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();

      if (isEditing) {
        _loadDeviceDetail();
      }
    });
    controller.loadValidationRules();

    _briboxSearchController.addListener(() {
      final allBriboxes =
          (controller.formOptions['briboxes'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();
      final query = _briboxSearchController.text.toLowerCase();
      _filteredBriboxes.value = allBriboxes
          .where((item) =>
              item['label'].toString().toLowerCase().contains(query) ||
              item['value'].toString().toLowerCase().contains(query))
          .toList();
    });

    _brandSearchController.addListener(() {
      final allBrands =
          (controller.formOptions['brands'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();
      final query = _brandSearchController.text.toLowerCase();
      _filteredBrands.value = allBrands
          .where((item) =>
              item['value'].toString().toLowerCase().contains(query) ||
              item['label']?.toString().toLowerCase().contains(query) == true)
          .toList();
    });

    _brandNameSearchController.addListener(() {
      final allBrandNames =
          (controller.formOptions['brandNames'] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();
      final query = _brandNameSearchController.text.toLowerCase();
      _filteredBrandNames.value = allBrandNames
          .where((item) =>
              item['value'].toString().toLowerCase().contains(query) ||
              item['label']?.toString().toLowerCase().contains(query) == true)
          .toList();
    });
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
    _briboxSearchController.dispose();
    _brandSearchController.dispose();
    _brandNameSearchController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.tryParse(devDateController.text) ?? DateTime.parse(''),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      devDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "brand": brandController.text,
      "brand_name": brandNameController.text,
      "serial_number": serialController.text,
      "asset_code": assetCodeController.text,
      "bribox_id": briboxId.value.isNotEmpty ? briboxId.value : null,
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
      if (deviceDetail.value == null) {
        Get.snackbar(
          "Error",
          "Data perangkat tidak tersedia untuk diupdate.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.error, color: Colors.white),
        );
        return;
      }
      success =
          await controller.updateDevice(deviceDetail.value!.deviceId, payload);
      if (success) {
        _showSuccessPopup(isEditing: true);
      }
    } else {
      success = await controller.createDevice(payload);
      if (success) {
        _showSuccessPopup(isEditing: false);
      }
    }
  }

  void _showSuccessPopup({required bool isEditing}) {
    final msg = isEditing
        ? "Perubahan berhasil disimpan!"
        : "Perangkat berhasil ditambahkan!";
    Get.snackbar(
      "Sukses",
      msg,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
      isDismissible: true,
    );
    Future.delayed(const Duration(seconds: 1), () => Get.back());
  }

  void _openBriboxSearchDialog() {
    final allBriboxes =
        (controller.formOptions['briboxes'] as List<dynamic>? ?? [])
            .cast<Map<String, dynamic>>();
    _filteredBriboxes.value = allBriboxes;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Kategori (Bribox)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _briboxSearchController,
                decoration: InputDecoration(
                  hintText: 'Cari kategori...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  if (_filteredBriboxes.isEmpty) {
                    return const Center(
                        child: Text('Kategori tidak ditemukan'));
                  }
                  return ListView.builder(
                    itemCount: _filteredBriboxes.length,
                    itemBuilder: (context, index) {
                      final item = _filteredBriboxes[index];
                      return ListTile(
                        title: Text(item['label'] ?? ''),
                        onTap: () {
                          briboxId.value = item['value'] ?? '';
                          briboxLabel.value = item['label'] ?? '';
                          Get.back();
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openSearchDropdownDialog({
    required String title,
    required TextEditingController searchController,
    required RxList<Map<String, dynamic>> filteredList,
    required Function(Map<String, dynamic>) onSelect,
  }) async {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Cari $title...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  if (filteredList.isEmpty) {
                    return const Center(child: Text('Data tidak ditemukan'));
                  }
                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return ListTile(
                        title: Text(item['value'] ?? item['label'] ?? ''),
                        onTap: () {
                          onSelect(item);
                          Get.back();
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label, IconData icon,
      {Color iconColor = Colors.blueAccent}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: iconColor),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
      ),
    );
  }

  Color _conditionColor(String value) {
    switch (value.toLowerCase()) {
      case 'rusak':
        return Colors.redAccent;
      case 'cadangan':
      case 'perlu pengecekan':
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        log("Loading device form...");
        return Container(
          color: Color(
              0xFFF4F6F8), // Mengubah latar belakang ke warna default Scaffold
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors
                  .blueAccent, // Mengubah warna indikator ke biru untuk kontras
            ),
          ),
        );
      }
      if (errorMessage.value.isNotEmpty) {
        log("Error: ${errorMessage.value}");
        return Center(
            child: Text(errorMessage.value,
                style: const TextStyle(color: Colors.red)));
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            isEditing ? 'Edit Perangkat' : 'Tambah Perangkat',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        backgroundColor: const Color(0xFFF4F6F8),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => _openSearchDropdownDialog(
                    title: 'Brand',
                    searchController: _brandSearchController,
                    filteredList: _filteredBrands,
                    onSelect: (item) {
                      brandController.text = item['value'] ?? '';
                    },
                  ),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: brandController,
                      decoration: _fieldDecoration('Brand', Icons.laptop_mac),
                      validator: (val) {
                        if ((controller.validationRules['rules']?['brand'] ??
                                    [])
                                .contains('required') &&
                            (val == null || val.isEmpty)) {
                          return controller.validationRules['messages']
                                  ?['brand.required'] ??
                              'Brand wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _openSearchDropdownDialog(
                    title: 'Brand Name / Model',
                    searchController: _brandNameSearchController,
                    filteredList: _filteredBrandNames,
                    onSelect: (item) {
                      brandNameController.text = item['value'] ?? '';
                    },
                  ),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: brandNameController,
                      decoration: _fieldDecoration(
                          'Brand Name / Model', Icons.devices_other),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: serialController,
                  decoration: _fieldDecoration(
                      'Serial Number', Icons.confirmation_number),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: assetCodeController,
                  decoration: _fieldDecoration('Asset Code', Icons.qr_code_2),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _openBriboxSearchDialog,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller:
                          TextEditingController(text: briboxLabel.value),
                      decoration:
                          _fieldDecoration('Kategori (Bribox)', Icons.category),
                      validator: (val) {
                        if (!isEditing &&
                            (briboxId.value.isEmpty ||
                                briboxLabel.value.isEmpty)) {
                          return 'Kategori wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: condition.value.isNotEmpty ? condition.value : null,
                  items:
                      (controller.formOptions['conditions'] as List<dynamic>? ??
                              [])
                          .map((item) => DropdownMenuItem<String>(
                                value: item['value'],
                                child: Text(item['value']),
                              ))
                          .toList(),
                  decoration: _fieldDecoration('Kondisi', Icons.verified,
                      iconColor: _conditionColor(condition.value.isNotEmpty
                          ? condition.value
                          : 'Baik')),
                  onChanged: (val) => condition.value = val ?? '',
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: status.value.isNotEmpty ? status.value : null,
                  items:
                      (controller.formOptions['statuses'] as List<dynamic>? ??
                              [])
                          .map((item) => DropdownMenuItem<String>(
                                value: item['value'],
                                child: Text(item['value']),
                              ))
                          .toList(),
                  decoration: _fieldDecoration('Status', Icons.toggle_on,
                      iconColor: Colors.orange),
                  onChanged: (val) => status.value = val ?? '',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: devDateController,
                  readOnly: true,
                  decoration: _fieldDecoration(
                      'Tanggal Keluar Barang', Icons.calendar_today),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 24),
                ...[
                  spec1Controller,
                  spec2Controller,
                  spec3Controller,
                  spec4Controller,
                  spec5Controller,
                ].asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      controller: entry.value,
                      decoration: _fieldDecoration(
                          'Spesifikasi $index', Icons.settings),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.save, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  label: Text(
                    isEditing ? 'Simpan Perubahan' : 'Tambah Perangkat',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
