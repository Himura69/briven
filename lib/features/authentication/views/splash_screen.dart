import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';
import 'package:flutter/scheduler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// ======== PARTICLE CLASS =========
class Particle {
  Offset position;
  double radius;
  double speed;
  double angle;
  Color color;

  Particle({
    required this.position,
    required this.radius,
    required this.speed,
    required this.angle,
    required this.color,
  });

  void update(Size size) {
    double dx = cos(angle) * speed;
    double dy = sin(angle) * speed;
    position = Offset(
      (position.dx + dx) % size.width,
      (position.dy + dy) % size.height,
    );
  }
}

// ======== PARTICLE PAINTER =========
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var p in particles) {
      paint.color = p.color.withOpacity(0.5 + Random().nextDouble() * 0.4);
      canvas.drawCircle(p.position, p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ======== MAIN SPLASH SCREEN =========
class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late List<Particle> _particles;
  late Ticker _ticker;
  final int particleCount = 150;

  late AnimationController _fadeController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _showWhiteOverlay = false;

  @override
  void initState() {
    super.initState();
    _initParticles();

    _ticker = createTicker((_) {
      setState(() {
        for (var p in _particles) {
          p.update(MediaQuery.of(context).size);
        }
      });
    });
    _ticker.start();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _fadeController.forward();

    // Jalankan animasi keluar dan pindah ke login
    Timer(const Duration(seconds: 4), () async {
      await _scaleController.forward(); // logo scale up
      await _fadeController.reverse();  // logo fade out

      setState(() => _showWhiteOverlay = true);

      await Future.delayed(const Duration(milliseconds: 300));
      _ticker.stop();
      Navigator.of(context).pushReplacement(_createRoute());
    });
  }

  void _initParticles() {
    final size = window.physicalSize / window.devicePixelRatio;
    final random = Random();
    _particles = List.generate(particleCount, (_) {
      return Particle(
        position: Offset(random.nextDouble() * size.width,
            random.nextDouble() * size.height),
        radius: random.nextDouble() * 2 + 1,
        speed: random.nextDouble() * 0.6 + 0.2,
        angle: random.nextDouble() * 2 * pi,
        color: [
          Colors.lightBlueAccent,
          Colors.white,
          Colors.cyanAccent,
          Colors.blue[100]!,
        ][random.nextInt(4)],
      );
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background gradasi terang + blur
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
          ),

          // Partikel
          CustomPaint(
            painter: ParticlePainter(_particles),
            child: Container(),
          ),

          // Logo Briven dengan animasi
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(36),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.lightBlueAccent.withOpacity(0.4),
                        blurRadius: 60,
                        spreadRadius: 25,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 160,
                    height: 160,
                  ),
                ),
              ),
            ),
          ),

          // White overlay flash saat transisi
          if (_showWhiteOverlay)
            Positioned.fill(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: 1,
                child: Container(color: Colors.white),
              ),
            ),

          // Credit
          const Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Powered by Briven Team",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
