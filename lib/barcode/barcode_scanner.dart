import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({super.key});

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {

  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Barcode"),
      ),

      body: MobileScanner(

        onDetect: (capture) {

          if(scanned) return;

          final code =
              capture.barcodes.first.rawValue;

          if(code != null){

            scanned = true;

            Navigator.pop(
              context,
              code,
            );
          }
        },
      ),
    );
  }
}