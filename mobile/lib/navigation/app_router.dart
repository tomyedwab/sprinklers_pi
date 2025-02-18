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
import 'routes.dart';

class AppRouterDelegate extends RouterDelegate<RouteLocation>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteLocation> {
  final WidgetRef ref;
  RouteLocation _currentRoute;
  bool _showConnectionSettings = false;

  AppRouterDelegate(this.ref) : _currentRoute = RouteLocation(AppRoute.dashboard) {
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

  RouteLocation get currentRoute => _currentRoute;

  void setCurrentRoute(RouteLocation route) {
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
  Future<void> setNewRoutePath(RouteLocation configuration) async {
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
    switch (_currentRoute.path) {
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
      default:
        return const DashboardScreen();
    }
  }
} 