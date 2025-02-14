import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/zones/zones_screen.dart';
import '../screens/schedules/schedules_screen.dart';
import '../screens/settings/settings_screen.dart';
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
    Widget screen;

    // Determine the current screen based on navigation state
    switch (state.currentTab) {
      case NavigationTab.dashboard:
        screen = const DashboardScreen();
        break;
      case NavigationTab.zones:
        screen = const ZonesScreen();
        break;
      case NavigationTab.schedules:
        screen = const SchedulesScreen();
        break;
      case NavigationTab.settings:
        screen = const SettingsScreen();
        break;
    }

    // Wrap the screen in our MainScreen shell
    return [
      MaterialPage(
        key: ValueKey(state.currentTab),
        child: MainScreen(child: screen),
      ),
    ];
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
    }
  }
} 