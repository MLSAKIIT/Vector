class EnvConfig {
  static const String firebaseDatabaseUrl = String.fromEnvironment(
    'FIREBASE_DB_URL',
    defaultValue: '',
  );

  static bool get isConfigured => firebaseDatabaseUrl.isNotEmpty;
}
