import 'package:freezed_annotation/freezed_annotation.dart';
import '../api/models/system_state.dart';

part 'system_state.freezed.dart';
part 'system_state.g.dart';

@freezed
class SystemState with _$SystemState {
  const factory SystemState({
    required String version,
    required bool isRunning,
    required int enabledZonesCount,
    required int schedulesCount,
    required DateTime currentTime,
    required int eventsCount,
    String? activeZoneName,
    Duration? remainingTime,
  }) = _SystemState;

  factory SystemState.fromJson(Map<String, dynamic> json) =>
      _$SystemStateFromJson(json);

  factory SystemState.fromApiModel(ApiSystemState api) {
    return SystemState(
      version: api.version,
      isRunning: api.run == 'on',
      enabledZonesCount: api.zones,
      schedulesCount: api.schedules,
      currentTime: DateTime.fromMillisecondsSinceEpoch(api.timenow * 1000),
      eventsCount: api.events,
      activeZoneName: api.onzone,
      remainingTime: api.offtime != null ? Duration(seconds: api.offtime!) : null,
    );
  }
} 