import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../navigation/navigation_state.dart';

class AppBottomNavBar extends ConsumerWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(navigationProvider.select((state) => state.currentTab));

    return BottomNavigationBar(
      currentIndex: currentTab.index,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.water_drop),
          label: 'Zones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Schedules',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: (index) {
        ref.read(navigationProvider.notifier).setTab(NavigationTab.values[index]);
      },
    );
  }
} 