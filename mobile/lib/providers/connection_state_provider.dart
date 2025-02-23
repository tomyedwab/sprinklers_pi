import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../navigation/app_router.dart';
import '../models/connection_settings.dart';
import '../providers/connection_settings_provider.dart';
import 'package:http/http.dart' as http;

enum AppConnectionStateEnum {
    uninitialized,
    unconfigured,
    unauthenticated,
    disconnected,
    connected,
    reconnecting
}

class AppConnectionState {
  final AppConnectionStateEnum state;
  final String? authRedirectUrl;

  const AppConnectionState({
    required this.state,
    this.authRedirectUrl,
  });
}


/// Provider to handle connection errors and automatic navigation
/// to the connection settings screen
final connectionStateProvider = NotifierProvider<ConnectionStateNotifier, AppConnectionState>(
  () => ConnectionStateNotifier(),
);

class ConnectionStateNotifier extends Notifier<AppConnectionState> {
  @override
  AppConnectionState build() {
    return const AppConnectionState(state: AppConnectionStateEnum.uninitialized);
  }

  /// Handle an API error and show the appropriate screen
  Future<void> handleError(Object error) async {
    if (error is ApiException && error.isRedirect) {
      state = AppConnectionState(
        state: AppConnectionStateEnum.unauthenticated,
        authRedirectUrl: error.redirectLocation,
      );
      return;
    }

    final settings = ref.read(connectionSettingsProvider);
    if (settings.baseUrl.isEmpty) {
      state = const AppConnectionState(state: AppConnectionStateEnum.unconfigured);
      return;
    }

    if (error is ApiException || error is TimeoutException || error is http.ClientException) {
      state = const AppConnectionState(state: AppConnectionStateEnum.disconnected);
    }
  }

  void handleSuccess() {
    state = const AppConnectionState(state: AppConnectionStateEnum.connected);
  }

  void reset() {
    state = const AppConnectionState(state: AppConnectionStateEnum.uninitialized);
  }
} 