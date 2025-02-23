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
    // Start in loading state and immediately load settings
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
      } else {
        state = ConnectionSettings.defaultSettings;
      }
    } catch (e) {
      // If loading fails, use default settings
      state = ConnectionSettings.defaultSettings;
    }
  }

  Future<void> updateSettings(ConnectionSettings settings) async {
    if (settings.baseUrl.isNotEmpty) {
      ApiConfig.setBaseUrl(settings.baseUrl);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(settings.toJson()),
    );
    state = settings;
  }
} 