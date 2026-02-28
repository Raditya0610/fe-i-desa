/// Application configuration
///
/// Controls various app settings including API mode (mock vs real)
class AppConfig {
  /// Toggle between mock API and real API
  ///
  /// Set to `true` to use mock data (no backend required)
  /// Set to `false` to use real backend API
  ///
  /// Mock mode is useful for:
  /// - Offline development
  /// - Testing without backend
  /// - Demos and presentations
  /// - UI development
  static const bool useMockApi = false;

  /// Enable debug logging
  static const bool enableDebugLogging = true;

  /// App version
  static const String appVersion = '1.0.0';

  /// App name
  static const String appName = 'Apps I-Desa';

  /// Get current mode as string
  static String get currentMode => useMockApi ? 'Mock Mode' : 'Live Mode';

  /// Check if in development mode
  static bool get isDevelopment => useMockApi;

  /// Check if in production mode
  static bool get isProduction => !useMockApi;
}
