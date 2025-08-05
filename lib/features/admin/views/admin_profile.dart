import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../admin/controllers/admin_profile_controller.dart';
import '../../../../core/widgets/loading_indicator.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminProfileController());

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingIndicator());
        }

        final user = controller.user.value;
        if (user == null) {
          return const Center(child: Text("Tidak dapat memuat profil."));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildRow("Nama", user.name),
            _buildRow("PN", user.pn),
            _buildRow("Departemen", user.department),
            _buildRow("Cabang", user.branch),
            _buildRow("Posisi", user.position),
          ],
        );
      }),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
