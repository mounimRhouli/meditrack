// Thrown when a database operation fails
class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}

// Thrown when a file operation fails (e.g., saving an image)
class LocalStorageException implements Exception {
  final String message;
  LocalStorageException(this.message);
}

// Thrown when authentication fails (if you implement the bonus login)
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}
