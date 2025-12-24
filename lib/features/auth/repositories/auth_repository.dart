import 'dart:async';
import '../../../core/errors/failures.dart';
import '../models/user.dart';
import '../services/firebase_auth_service.dart';

// A simple Result wrapper pattern
// In larger apps, we might use a library like 'fpdart' or 'dartz' for this.
class Result<T> {
  final T? data;
  final Failure? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  bool get isSuccess => error == null;
}

class AuthRepository {
  final FirebaseAuthService _authService;

  AuthRepository(this._authService);

  // ---------------------------------------------------------------------------
  // Stream: Real-time Auth Status
  // ---------------------------------------------------------------------------
  Stream<User?> get userStream => _authService.authStateChanges;

  // ---------------------------------------------------------------------------
  // Login
  // ---------------------------------------------------------------------------
  Future<Result<User>> login(String email, String password) async {
    try {
      final user = await _authService.signIn(email: email, password: password);
      if (user == null) {
        return Result.failure(
          const ServerFailure('Login failed: No user returned'),
        );
      }
      return Result.success(user);
    } catch (e) {
      // Architect's Note: We catch the raw exception from the Service
      // and convert it into a clean Domain Failure.
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Register
  // ---------------------------------------------------------------------------
  Future<Result<User>> register(String email, String password) async {
    try {
      final user = await _authService.register(
        email: email,
        password: password,
      );
      if (user == null) {
        return Result.failure(
          const ServerFailure('Registration failed: No user returned'),
        );
      }
      return Result.success(user);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Logout
  // ---------------------------------------------------------------------------
  Future<void> logout() async {
    await _authService.signOut();
  }
}
