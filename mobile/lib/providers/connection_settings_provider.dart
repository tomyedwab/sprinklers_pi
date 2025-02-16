import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/connection_settings.dart';
import '../api/api_config.dart';

final connectionSettingsProvider = NotifierProvider<ConnectionSettingsNotifier, ConnectionSettings>(
  () => ConnectionSettingsNotifier(),
);

class ConnectionSettingsNotifier extends Notifier<ConnectionSettings> {
  static const _storageKey = 'connection_settings';

  @override
  ConnectionSettings build() {
    // Load settings from storage on initialization
    _loadSettings();
    return ConnectionSettings.defaultSettings;
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null) {
        final settings = ConnectionSettings.fromJson(
          Map<String, dynamic>.from(
            jsonDecode(jsonStr),
          ),
        );
        state = settings;
        if (settings.baseUrl.isNotEmpty) {
          ApiConfig.setBaseUrl(settings.baseUrl);
        }
      }
    } catch (e) {
      // If loading fails, keep using default settings
      // In a production app, we might want to notify the user
    }
  }

  Future<void> updateSettings(ConnectionSettings settings) async {
    state = settings;
    if (settings.baseUrl.isNotEmpty) {
      ApiConfig.setBaseUrl(settings.baseUrl);
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _storageKey,
        jsonEncode(settings.toJson()),
      );
    } catch (e) {
      // Handle storage errors
      // In a production app, we might want to notify the user
    }
  }
} 