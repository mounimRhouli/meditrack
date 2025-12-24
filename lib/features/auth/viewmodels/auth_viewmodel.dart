import 'dart:async';
import 'package:flutter/foundation.dart'; // For ChangeNotifier
import '../models/auth_state.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  // ---------------------------------------------------------------------------
  // State Management
  // ---------------------------------------------------------------------------
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  StreamSubscription<User?>? _authSubscription;

  AuthViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    // Architect's Note: Immediately listen to the stream upon initialization.
    // This handles "Auto-Login" when the app restarts.
    _authSubscription = _authRepository.userStream.listen(_onAuthStateChanged);
  }

  // Getters for the UI to consume
  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  // ---------------------------------------------------------------------------
  // Stream Listener (The "Auto-Pilot")
  // ---------------------------------------------------------------------------
  void _onAuthStateChanged(User? user) {
    if (user != null) {
      _user = user;
      _status = AuthStatus.authenticated;
    } else {
      _user = null;
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // User Actions (Business Logic)
  // ---------------------------------------------------------------------------

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepository.login(email, password);

    if (!result.isSuccess) {
      _status = AuthStatus.error;
      _errorMessage = result.error?.message ?? "Unknown login error";
    }
    // Success is handled automatically by the _onAuthStateChanged stream listener
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepository.register(email, password);

    if (!result.isSuccess) {
      _status = AuthStatus.error;
      _errorMessage = result.error?.message ?? "Unknown registration error";
    }
    // Success is handled by stream
    notifyListeners();
  }

  Future<void> logout() async {
    await _authRepository.logout();
    // _onAuthStateChanged will fire and set status to unauthenticated
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------
  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
