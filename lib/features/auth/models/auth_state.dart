/// Represents the distinct phases of the Authentication lifecycle.
///
/// usage:
/// if (state == AuthStatus.authenticated) { showHome(); }
enum AuthStatus {
  /// App has just started, checking if user is already logged in (persistence)
  initial,

  /// Waiting for Firebase/Database response
  loading,

  /// User is successfully logged in
  authenticated,

  /// User is not logged in (Guest)
  unauthenticated,

  /// An error occurred during login/register
  error,
}

/// Architect's Bonus: Helper methods for cleaner UI logic
extension AuthStatusX on AuthStatus {
  bool get isLoading => this == AuthStatus.loading;
  bool get isAuthenticated => this == AuthStatus.authenticated;
  bool get isError => this == AuthStatus.error;
}
