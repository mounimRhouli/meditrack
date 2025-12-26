// lib/features/medications/widgets/barcode_scan_button.dart

import 'package:flutter/material.dart';
import 'package:meditrack/shared/widgets/custom_button.dart';

class BarcodeScanButton extends StatelessWidget {
  final ValueChanged<String> onBarcodeScanned;

  const BarcodeScanButton({
    Key? key,
    required this.onBarcodeScanned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Scanner un code-barres',
      isSecondary: true,
      onPressed: () {
        // TODO: Naviguer vers l'écran du scanner
        // context.pushNamed(AppRouteNames.barcodeScanner);
        // Pour l'instant, on simule un scan
        onBarcodeScanned('1234567890123');
      },
    );
  }
}