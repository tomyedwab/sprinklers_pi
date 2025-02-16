import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/zones/zones_screen.dart';
import '../screens/schedules/schedules_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/diagnostics/diagnostics_screen.dart';
import '../screens/connection/connection_settings_screen.dart';
import '../main.dart';
import '../providers/connection_settings_provider.dart';

enum AppRoute {
  dashboard,
  zones,
  schedules,
  settings,
  diagnostics,
  connection,
}

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  final WidgetRef ref;
  AppRoute _currentRoute;
  bool _showConnectionSettings = false;

  AppRouterDelegate(this.ref) : _currentRoute = AppRoute.dashboard {
    // Check if we need to show connection settings on startup
    final settingsAsync = ref.read(connectionSettingsProvider);
    settingsAsync.whenData((settings) {
      if (settings.baseUrl.isEmpty) {
        _showConnectionSettings = true;
      }
    });
  }

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  AppRoute get currentRoute => _currentRoute;

  void setCurrentRoute(AppRoute route) {
    _currentRoute = route;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    // Watch for connection settings changes
    final settingsAsync = ref.watch(connectionSettingsProvider);

    return settingsAsync.when(
      data: (settings) => Navigator(
        key: navigatorKey,
        pages: [
          MaterialPage(
            key: ValueKey(_currentRoute),
            child: MainScreen(child: _buildCurrentScreen()),
          ),
          if (_showConnectionSettings || settings.baseUrl.isEmpty)
            MaterialPage(
              key: const ValueKey('ConnectionSettings'),
              child: const ConnectionSettingsScreen(isError: true),
            ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }

          if (_showConnectionSettings) {
            // Only allow dismissing the connection settings if we have a valid URL
            if (settings.baseUrl.isNotEmpty) {
              hideConnectionSettings();
              return true;
            }
            return false;
          }

          return true;
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(child: Text('Error loading settings')),
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    setCurrentRoute(configuration);
  }

  void showConnectionSettings() {
    _showConnectionSettings = true;
    notifyListeners();
  }

  void hideConnectionSettings() {
    _showConnectionSettings = false;
    notifyListeners();
  }

  Widget _buildCurrentScreen() {
    switch (_currentRoute) {
      case AppRoute.dashboard:
        return const DashboardScreen();
      case AppRoute.zones:
        return const ZonesScreen();
      case AppRoute.schedules:
        return const SchedulesScreen();
      case AppRoute.settings:
        return const SettingsScreen();
      case AppRoute.diagnostics:
        return const DiagnosticsScreen();
      case AppRoute.connection:
        return const ConnectionSettingsScreen();
    }
  }
} 