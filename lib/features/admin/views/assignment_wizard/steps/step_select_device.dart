import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../admin/controllers/admin_assignment_wizard_controller.dart';
import '../../../../admin/models/assignment_form_options_model.dart';

class StepSelectDevice extends StatelessWidget {
  final controller = Get.find<AdminAssignmentWizardController>();

  StepSelectDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedDevice.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Perangkat',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _showSearchDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selected?.label ?? 'Pilih perangkat',
                      style: TextStyle(
                        color: selected != null ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController();
    List<FormOption> filtered = List.from(controller.deviceOptions);

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            void filter(String query) {
              setState(() {
                filtered = controller.deviceOptions
                    .where((item) =>
                        item.label.toLowerCase().contains(query.toLowerCase()))
                    .toList();
              });
            }

            return AlertDialog(
              title: const Text("Cari Perangkat"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: filter,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Ketik nama perangkat...',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 300,
                    width: double.maxFinite,
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, index) {
                        final item = filtered[index];
                        return ListTile(
                          title: Text(item.label),
                          onTap: () {
                            controller.selectedDevice.value = item;
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
