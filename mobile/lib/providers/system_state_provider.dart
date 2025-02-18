import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/system_state.dart';
import '../providers/api_provider.dart';

part 'system_state_provider.g.dart';

@riverpod
class SystemStateNotifier extends _$SystemStateNotifier {
  @override
  Future<SystemState> build() async {
    final client = ref.read(apiClientProvider);
    final apiState = await client.getSystemState();
    return SystemState(
      version: apiState.version,
      isRunning: apiState.run == 'on',
      enabledZonesCount: apiState.zones,
      schedulesCount: apiState.schedules,
      currentTime: DateTime.fromMillisecondsSinceEpoch(apiState.timenow * 1000),
      eventsCount: apiState.events,
      activeZoneName: apiState.onzone,
      remainingTime: apiState.offtime != null ? Duration(seconds: apiState.offtime!) : null,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  Future<void> setEnabled(bool enabled) async {
    state = const AsyncValue.loading();
    try {
      final client = ref.read(apiClientProvider);
      await client.setSystemEnabled(enabled);
      state = await AsyncValue.guard(() => build());
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
} 