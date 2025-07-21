// AdminNavBar sekarang cuma wrapper kosong (opsional)
import 'package:flutter/material.dart';

class AdminNavBar extends StatelessWidget {
  const AdminNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // tidak perlu lagi karena sudah di root screen
  }
}
