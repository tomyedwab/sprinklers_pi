import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../navigation/app_router.dart';
import 'auth_provider.dart';

/// Provider to handle connection errors and automatic navigation
/// to the connection settings screen
final connectionErrorProvider = NotifierProvider<ConnectionErrorNotifier, bool>(
  () => ConnectionErrorNotifier(),
);

class ConnectionErrorNotifier extends Notifier<bool> {
  @override
  bool build() => false;  // Initially no error

  /// Handle an API error and show the appropriate screen
  Future<void> handleError(BuildContext context, Object error) async {
    if (error is ApiException) {
      // If we're already showing an error, don't stack them
      if (state) return;

      state = true;

      if (error.isRedirect) {
        // Handle auth redirects
        await ref.read(authProvider.notifier).handleApiError(context, error);
      } else {
        // Show connection settings screen for other errors
        if (!context.mounted) return;
        final router = Router.of(context).routerDelegate as AppRouterDelegate;
        router.showConnectionSettings();
      }

      state = false;
    }
  }

  /// Check if we need to show the connection settings screen on app start
  Future<void> checkInitialConnection(BuildContext context) async {
    try {
      // Try to get the system state as a connection test
      final apiClient = ref.read(apiClientProvider);
      await apiClient.getSystemState();
    } catch (e) {
      if (!context.mounted) return;
      await handleError(context, e);
    }
  }
} 