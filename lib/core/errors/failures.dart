abstract class Failure {
  final String message;
  Failure(this.message);
}

class DatabaseFailure extends Failure {
  DatabaseFailure(super.message);
}

class LocalStorageFailure extends Failure {
  LocalStorageFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}
