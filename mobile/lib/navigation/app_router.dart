import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/zones/zones_screen.dart';
import '../screens/schedules/schedules_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/diagnostics/diagnostics_screen.dart';
import '../navigation/navigation_state.dart';
import '../main.dart';

class AppRouterDelegate extends RouterDelegate<RouteLocation>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteLocation> {
  final WidgetRef ref;
  final GlobalKey<NavigatorState> _navigatorKey;

  AppRouterDelegate(this.ref) : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  RouteLocation? get currentConfiguration {
    final state = ref.read(navigationProvider);
    switch (state.currentTab) {
      case NavigationTab.dashboard:
        return RouteLocation(AppRoute.dashboard);
      case NavigationTab.zones:
        return state.selectedItemId != null
            ? RouteLocation(AppRoute.zoneDetail, {'id': state.selectedItemId!})
            : RouteLocation(AppRoute.zones);
      case NavigationTab.schedules:
        return state.selectedItemId != null
            ? RouteLocation(AppRoute.scheduleDetail, {'id': state.selectedItemId!})
            : RouteLocation(AppRoute.schedules);
      case NavigationTab.settings:
        return RouteLocation(AppRoute.settings);
      case NavigationTab.diagnostics:
        return RouteLocation(AppRoute.diagnostics);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _buildPages(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        ref.read(navigationProvider.notifier).setSelectedItem(null);
        return true;
      },
    );
  }

  List<Page<dynamic>> _buildPages() {
    final state = ref.watch(navigationProvider);
    return [
      MaterialPage(
        child: MainScreen(
          child: _buildScreen(state),
        ),
      ),
    ];
  }

  Widget _buildScreen(NavigationState state) {
    switch (state.currentTab) {
      case NavigationTab.dashboard:
        return const DashboardScreen();
      case NavigationTab.zones:
        return const ZonesScreen();
      case NavigationTab.schedules:
        return const SchedulesScreen();
      case NavigationTab.settings:
        return const SettingsScreen();
      case NavigationTab.diagnostics:
        return const DiagnosticsScreen();
    }
  }

  @override
  Future<void> setNewRoutePath(RouteLocation configuration) async {
    final notifier = ref.read(navigationProvider.notifier);
    
    switch (configuration.path) {
      case AppRoute.dashboard:
        notifier.setTab(NavigationTab.dashboard);
        break;
      case AppRoute.zones:
        notifier.setTab(NavigationTab.zones);
        break;
      case AppRoute.zoneDetail:
        notifier.setTab(NavigationTab.zones);
        notifier.setSelectedItem(configuration.params['id']);
        break;
      case AppRoute.schedules:
        notifier.setTab(NavigationTab.schedules);
        break;
      case AppRoute.scheduleDetail:
        notifier.setTab(NavigationTab.schedules);
        notifier.setSelectedItem(configuration.params['id']);
        break;
      case AppRoute.settings:
        notifier.setTab(NavigationTab.settings);
        break;
      case AppRoute.diagnostics:
        notifier.setTab(NavigationTab.diagnostics);
        break;
    }
  }
} 