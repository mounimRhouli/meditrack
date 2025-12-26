import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ocr_service.dart';

class OCRState {
  final bool isProcessing;
  final String? extractedText;
  final String? error;

  OCRState({
    this.isProcessing = false,
    this.extractedText,
    this.error,
  });

  OCRState copyWith({
    bool? isProcessing,
    String? extractedText,
    String? error,
  }) {
    return OCRState(
      isProcessing: isProcessing ?? this.isProcessing,
      extractedText: extractedText ?? this.extractedText,
      error: error ?? this.error,
    );
  }
}

class OCRViewModel extends StateNotifier<OCRState> {
  final OCRService _ocrService;

  OCRViewModel(this._ocrService) : super(OCRState());

  /// Triggers the ML Kit text recognition logic.
  Future<void> scanImage(String imagePath) async {
    state = state.copyWith(isProcessing: true, error: null, extractedText: null);
    try {
      final text = await _ocrService.extractTextFromImage(imagePath);
      state = state.copyWith(isProcessing: false, extractedText: text);
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: "Failed to recognize text: $e");
    }
  }

  /// Clears the current OCR state for a new scan.
  void reset() {
    state = OCRState();
  }
}