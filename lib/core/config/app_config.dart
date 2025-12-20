class AppConfig {
  AppConfig._();

  // Flag to check if we are in debug mode
  static const bool isDebugMode = true;

  // Database version (useful for SQLite migrations)
  static const int databaseVersion = 1;
  static const String databaseName = 'meditrack.db';
}
