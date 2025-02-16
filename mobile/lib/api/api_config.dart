import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/connection_settings_provider.dart';

/// API endpoint configuration
class ApiConfig {
  static String? _baseUrl;

  /// The base URL for the Sprinklers Pi API
  /// Throws a StateError if the base URL has not been configured
  static String get baseUrl {
    if (_baseUrl?.isEmpty ?? true) {
      throw StateError('API base URL has not been configured. Please set the connection settings first.');
    }
    return _baseUrl!;
  }

  /// Initialize the base URL from connection settings
  static void initialize(WidgetRef ref) {
    final url = ref.read(connectionSettingsProvider).baseUrl;
    if (url.isEmpty) {
      throw StateError('Cannot initialize API with an empty base URL');
    }
    _baseUrl = url;
  }

  /// Update the base URL
  /// Throws an ArgumentError if the URL is empty
  static void setBaseUrl(String url) {
    if (url.isEmpty) {
      throw ArgumentError('Base URL cannot be empty');
    }
    _baseUrl = url;
  }
  
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