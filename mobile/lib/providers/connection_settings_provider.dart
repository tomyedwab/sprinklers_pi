import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/connection_settings.dart';
import '../api/api_config.dart';

final connectionSettingsProvider = NotifierProvider<ConnectionSettingsNotifier, AsyncValue<ConnectionSettings>>(
  () => ConnectionSettingsNotifier(),
);

class ConnectionSettingsNotifier extends Notifier<AsyncValue<ConnectionSettings>> {
  static const _storageKey = 'connection_settings';

  @override
  AsyncValue<ConnectionSettings> build() {
    // Start in loading state and immediately load settings
    _loadSettings();
    return const AsyncValue.loading();
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
        state = AsyncValue.data(settings);
        if (settings.baseUrl.isNotEmpty) {
          ApiConfig.setBaseUrl(settings.baseUrl);
        }
      } else {
        state = AsyncValue.data(ConnectionSettings.defaultSettings);
      }
    } catch (e) {
      // If loading fails, use default settings
      state = AsyncValue.data(ConnectionSettings.defaultSettings);
    }
  }

  Future<void> updateSettings(ConnectionSettings settings) async {
    state = const AsyncValue.loading();
    try {
      if (settings.baseUrl.isNotEmpty) {
        ApiConfig.setBaseUrl(settings.baseUrl);
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _storageKey,
        jsonEncode(settings.toJson()),
      );
      state = AsyncValue.data(settings);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
} 