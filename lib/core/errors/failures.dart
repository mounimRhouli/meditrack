/// Classe de base pour toutes les erreurs
abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// Erreurs serveur
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

/// Erreurs cache
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

/// Erreurs base de données
class DatabaseFailure extends Failure {
  const DatabaseFailure(String message) : super(message);
}

/// Erreurs notifications
class NotificationFailure extends Failure {
  const NotificationFailure(String message) : super(message);
}

/// Erreurs de mapping (DTO ↔ Model)
class MappingFailure extends Failure {
  const MappingFailure(String message) : super(message);
}
