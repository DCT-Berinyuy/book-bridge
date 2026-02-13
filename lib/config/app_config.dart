/// Environment configuration for the app
/// This file loads environment variables from the .env file
///
/// NOTE: The .env file should never be committed to version control
/// and should be added to .gitignore
class AppConfig {
  // Supabase configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // CamPay configuration
  static const String campayAppId = String.fromEnvironment(
    'CAMPAY_APP_ID',
    defaultValue: '',
  );
  static const String campayAppUsername = String.fromEnvironment(
    'CAMPAY_APP_USERNAME',
    defaultValue: '',
  );
  static const String campayAppPassword = String.fromEnvironment(
    'CAMPAY_APP_PASSWORD',
    defaultValue: '',
  );
  static const String campayBaseUrl = String.fromEnvironment(
    'CAMPAY_BASE_URL',
    defaultValue: 'https://demo.campay.net/api',
  );
}
