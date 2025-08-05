import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../admin/controllers/admin_profile_controller.dart';
import '../../../../core/widgets/loading_indicator.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminProfileController());
    const primaryColor = Color(0xFF1976D2); // Warna Biru Primary

    return Scaffold(
      backgroundColor:
          primaryColor.withOpacity(0.05), // Latar belakang yang lebih lembut
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingIndicator());
        }

        final user = controller.user.value;
        if (user == null) {
          return const Center(child: Text("Tidak dapat memuat profil."));
        }

        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Profil dengan animasi
                      const SizedBox(height: 16),
                      FadeInTransition(
                        duration: const Duration(milliseconds: 600),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: primaryColor,
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeInTransition(
                        duration: const Duration(milliseconds: 700),
                        child: Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Detail Profil dengan animasi
                      SlideInUpTransition(
                        duration: const Duration(milliseconds: 800),
                        child: _buildProfileRow(
                          icon: Icons.fingerprint,
                          label: "PN",
                          value: user.pn,
                          primaryColor: primaryColor,
                        ),
                      ),
                      SlideInUpTransition(
                        duration: const Duration(milliseconds: 900),
                        child: _buildProfileRow(
                          icon: Icons.business,
                          label: "Departemen",
                          value: user.department,
                          primaryColor: primaryColor,
                        ),
                      ),
                      SlideInUpTransition(
                        duration: const Duration(milliseconds: 1000),
                        child: _buildProfileRow(
                          icon: Icons.location_on,
                          label: "Cabang",
                          value: user.branch,
                          primaryColor: primaryColor,
                        ),
                      ),
                      SlideInUpTransition(
                        duration: const Duration(milliseconds: 1100),
                        child: _buildProfileRow(
                          icon: Icons.work,
                          label: "Posisi",
                          value: user.position,
                          primaryColor: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileRow({
    required IconData icon,
    required String label,
    required String value,
    required Color primaryColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Tambahkan widget transisi di luar class utama
class FadeInTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const FadeInTransition({
    super.key,
    required this.child,
    required this.duration,
  });

  @override
  _FadeInTransitionState createState() => _FadeInTransitionState();
}

class _FadeInTransitionState extends State<FadeInTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

class SlideInUpTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const SlideInUpTransition({
    super.key,
    required this.child,
    required this.duration,
  });

  @override
  _SlideInUpTransitionState createState() => _SlideInUpTransitionState();
}

class _SlideInUpTransitionState extends State<SlideInUpTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation =
        Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}
