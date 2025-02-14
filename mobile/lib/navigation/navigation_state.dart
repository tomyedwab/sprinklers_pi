import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavigationTab {
  dashboard,
  zones,
  schedules,
  settings,
}

class NavigationState {
  final NavigationTab currentTab;
  final String? selectedItemId;

  const NavigationState({
    this.currentTab = NavigationTab.dashboard,
    this.selectedItemId,
  });

  NavigationState copyWith({
    NavigationTab? currentTab,
    String? selectedItemId,
  }) {
    return NavigationState(
      currentTab: currentTab ?? this.currentTab,
      selectedItemId: selectedItemId ?? this.selectedItemId,
    );
  }
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(const NavigationState());

  void setTab(NavigationTab tab) {
    state = state.copyWith(currentTab: tab, selectedItemId: null);
  }

  void setSelectedItem(String? id) {
    state = state.copyWith(selectedItemId: id);
  }
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>((ref) {
  return NavigationNotifier();
}); 