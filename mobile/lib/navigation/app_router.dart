import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/zones/zones_screen.dart';
import '../screens/schedules/schedules_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/diagnostics/diagnostics_screen.dart';
import '../screens/connection/connection_settings_screen.dart';
import '../screens/auth/auth_screen.dart';
import '../main.dart';
import '../providers/connection_settings_provider.dart';
import '../providers/connection_state_provider.dart';
import 'routes.dart';

class AppRouterDelegate extends RouterDelegate<RouteLocation>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteLocation> {
  final WidgetRef ref;
  RouteLocation _currentRoute;

  AppRouterDelegate(this.ref) : _currentRoute = RouteLocation(AppRoute.dashboard) {
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
    final connectionState = ref.watch(connectionStateProvider);

    if (connectionState.state == AppConnectionStateEnum.unauthenticated) {
      return const AuthScreen();
    }

    if (connectionState.state != AppConnectionStateEnum.connected && connectionState.state != AppConnectionStateEnum.reconnecting) {
      return ConnectionSettingsScreen(connectionState: connectionState);
    }

    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: ValueKey(_currentRoute),
          child: MainScreen(child: _buildCurrentScreen()),
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteLocation configuration) async {
    setCurrentRoute(configuration);
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