// lib/features/medications/viewmodels/barcode_scanner_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:meditrack/features/medications/services/barcode_scanner_service.dart';

class BarcodeScannerViewModel extends ChangeNotifier {
  final BarcodeScannerService _service;
  String? _scannedBarcode;
  bool _isProcessing = false;
  String? _errorMessage;

  BarcodeScannerViewModel(this._service);

  String? get scannedBarcode => _scannedBarcode;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

  /// Appelé lorsque la caméra détecte un code-barres.
  Future<void> onBarcodeDetected(String barcode) async {
    if (_isProcessing) return; // Éviter les traitements multiples

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    // Ici, vous pourriez faire une validation plus complexe
    final isValid = await _service.isValidBarcode(barcode);

    if (isValid) {
      _scannedBarcode = barcode;
    } else {
      _errorMessage = 'Code-barres invalide. Veuillez réessayer.';
    }

    _isProcessing = false;
    notifyListeners();
  }

  void resetError() {
    _errorMessage = null;
    notifyListeners();
  }
}