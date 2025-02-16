/// API endpoint configuration
class ApiConfig {
  /// The base URL for the Sprinklers Pi API
  /// In development, this points to our proxy server
  /// In production, this should be set to the full server URL
  static String baseUrl = 'http://localhost:8000';
  
  /// Default timeout duration for API requests
  static const Duration timeout = Duration(seconds: 10);
  
  /// API endpoints
  static const String zones = '/json/zones';
  static const String state = '/json/state';
  static const String setZones = '/bin/setZones';
  static const String schedules = '/json/schedules';
  static const String schedule = '/json/schedule';
  static const String setSchedule = '/bin/setSched';
  static const String deleteSchedule = '/bin/delSched';
  static const String manualControl = '/bin/manual';
  static const String quickSchedule = '/bin/setQSched';
  static const String settings = '/json/settings';
  static const String saveSettings = '/bin/settings';
  static const String weatherCheck = '/json/wcheck';
  static const String systemReset = '/bin/reset';
  static const String factoryReset = '/bin/factory';
  static const String logs = '/json/logs';
  static const String tableLogs = '/json/tlogs';
  static const String chatterBox = '/bin/chatter';
} 