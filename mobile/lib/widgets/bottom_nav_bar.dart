import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../navigation/app_router.dart';
import '../navigation/routes.dart';

class AppBottomNavBar extends ConsumerWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = Router.of(context).routerDelegate as AppRouterDelegate;
    final currentRoute = router.currentRoute;

    // Map of route paths to their indices
    final routeIndices = {
      AppRoute.dashboard: 0,
      AppRoute.zones: 1,
      AppRoute.schedules: 2,
      AppRoute.settings: 3,
      AppRoute.diagnostics: 4,
    };

    // Get the current index based on the route path
    final selectedIndex = routeIndices[currentRoute.path] ?? 0;

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        // Map of indices to route paths
        final routes = [
          AppRoute.dashboard,
          AppRoute.zones,
          AppRoute.schedules,
          AppRoute.settings,
          AppRoute.diagnostics,
        ];
        router.setCurrentRoute(RouteLocation(routes[index]));
      },
      backgroundColor: const Color(0xFFf9fbfa), // Card Background from design spec
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.1), // 10% opacity black
      height: 72, // Increased height for better touch targets
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      indicatorColor: Colors.transparent, // Remove the indicator background
      destinations: [
        for (final destination in [
          (Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
          (Icons.water_drop_outlined, Icons.water_drop, 'Zones'),
          (Icons.schedule_outlined, Icons.schedule, 'Schedules'),
          (Icons.settings_outlined, Icons.settings, 'Settings'),
          (Icons.bug_report_outlined, Icons.bug_report, 'Diagnostics'),
        ])
          NavigationDestination(
            icon: Icon(
              destination.$1,
              color: const Color(0xFF032e3f), // Icon Color from design spec
              size: 24, // Icon size from design spec
            ),
            selectedIcon: Icon(
              destination.$2,
              color: const Color(0xFF057257), // Accent Color from design spec
              size: 24,
            ),
            label: destination.$3,
          ),
      ],
    );
  }
} 