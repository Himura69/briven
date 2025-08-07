import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../../admin/controllers/qr_scanner_controller.dart';
import 'qr_scan_result_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanned = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isScanned) return;

      isScanned = true;
      controller.pauseCamera();

      final qrCode = scanData.code;

      if (qrCode != null && qrCode.startsWith("briven-")) {
        final scannerController = Get.find<QrScannerController>();
        await scannerController.fetchScanResult(qrCode);

        // Navigasi ke result screen
        Get.to(() => const QrScanResultScreen());
      } else {
        Get.snackbar(
          "QR Tidak Valid",
          "Format QR code tidak sesuai (harus prefix briven-)",
        );
        controller.resumeCamera();
        isScanned = false;
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // QR Camera View
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.blue,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300,
            ),
          ),

          // Gambar di atas kamera
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset(
                'assets/images/Frame 16.png',
                width: 220,
                height: 150,
              ),
            ),
          ),

          // Tombol Back di kiri atas
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Get.back(); // Kembali ke halaman sebelumnya
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
