import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart'; // Requires 'url_launcher' in pubspec.yaml
import '../models/emergency_info.dart';
import '../repositories/emergency_repository.dart';

enum EmergencyStatus { initial, loading, loaded, error }

class EmergencyViewModel extends ChangeNotifier {
  final EmergencyRepository _repository;

  EmergencyViewModel({required EmergencyRepository repository})
    : _repository = repository;

  // ---------------------------------------------------------------------------
  // STATE
  // ---------------------------------------------------------------------------
  EmergencyInfo? _info;
  EmergencyStatus _status = EmergencyStatus.initial;
  String? _errorMessage;

  EmergencyInfo? get info => _info;
  EmergencyStatus get status => _status;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == EmergencyStatus.loading;

  // ---------------------------------------------------------------------------
  // ACTIONS: Load Data
  // ---------------------------------------------------------------------------
  Future<void> loadEmergencyInfo(String userId) async {
    _status = EmergencyStatus.loading;
    notifyListeners();

    final result = await _repository.getEmergencyInfo(userId);

    if (result.isSuccess) {
      _info = result.data;
      _status = EmergencyStatus.loaded;
    } else {
      _status = EmergencyStatus.error;
      _errorMessage = result.error?.message ?? "Failed to load emergency info";
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // ACTIONS: Update Data
  // ---------------------------------------------------------------------------
  Future<void> updateInfo(EmergencyInfo newInfo) async {
    _info = newInfo; // Optimistic update
    notifyListeners();

    await _repository.updateEmergencyInfo(newInfo);
  }

  // ---------------------------------------------------------------------------
  // ACTIONS: Phone Calls (Critical Functionality)
  // ---------------------------------------------------------------------------
  Future<void> callNumber(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _errorMessage = "Could not launch dialer for $phoneNumber";
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Error launching call: $e";
      notifyListeners();
    }
  }

  Future<void> callAmbulance() async {
    // In a real app, this might be dynamic based on user location (911 vs 112)
    // For now, we hardcode a standard emergency number or prompts the user.
    await callNumber("911");
  }
}
