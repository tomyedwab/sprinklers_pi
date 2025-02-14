import 'package:freezed_annotation/freezed_annotation.dart';
import '../api/models/schedule.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

@freezed
class ScheduleTime with _$ScheduleTime {
  const factory ScheduleTime({
    required String time,      // HH:MM format
    required bool isEnabled,
  }) = _ScheduleTime;

  factory ScheduleTime.fromJson(Map<String, dynamic> json) =>
      _$ScheduleTimeFromJson(json);
}

@freezed
class ScheduleZone with _$ScheduleZone {
  const factory ScheduleZone({
    required Duration duration,
    required bool isEnabled,
  }) = _ScheduleZone;

  factory ScheduleZone.fromJson(Map<String, dynamic> json) =>
      _$ScheduleZoneFromJson(json);
}

enum DayRestriction {
  none(0),
  oddDays(1),
  evenDays(2);

  final int value;
  const DayRestriction(this.value);

  factory DayRestriction.fromValue(int value) {
    return DayRestriction.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DayRestriction.none,
    );
  }
}

@freezed
class Schedule with _$Schedule {
  const factory Schedule({
    required int id,
    required String name,
    required bool isEnabled,
    required bool isDayBased,  // true = day-based, false = interval-based
    required int interval,     // Days between runs (1-20)
    required DayRestriction restriction,
    required bool isSundayEnabled,
    required bool isMondayEnabled,
    required bool isTuesdayEnabled,
    required bool isWednesdayEnabled,
    required bool isThursdayEnabled,
    required bool isFridayEnabled,
    required bool isSaturdayEnabled,
    required List<ScheduleTime> times,
    required List<ScheduleZone> zones,
    String? nextRun,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  const Schedule._();

  bool get isActive => isEnabled && times.any((t) => t.isEnabled);
  bool get hasActiveZones => zones.any((z) => z.isEnabled);

  List<bool> get weekdayStatus => [
    isSundayEnabled,
    isMondayEnabled,
    isTuesdayEnabled,
    isWednesdayEnabled,
    isThursdayEnabled,
    isFridayEnabled,
    isSaturdayEnabled,
  ];

  bool isEnabledForDay(int weekday) {
    // weekday is 1-7 where 1 is Monday
    // Convert to 0-6 where 0 is Sunday to match our array
    final index = (weekday + 5) % 7;
    return weekdayStatus[index];
  }
}

extension ApiScheduleX on Schedule {
  static Schedule fromApiSchedule(int id, ApiScheduleDetail api, {String? nextRun}) {
    return Schedule(
      id: id,
      name: api.name,
      isEnabled: api.enabled == 'on',
      isDayBased: api.type == 'on',
      interval: api.interval,
      restriction: DayRestriction.fromValue(api.restrict),
      isSundayEnabled: api.d1 == 'on',
      isMondayEnabled: api.d2 == 'on',
      isTuesdayEnabled: api.d3 == 'on',
      isWednesdayEnabled: api.d4 == 'on',
      isThursdayEnabled: api.d5 == 'on',
      isFridayEnabled: api.d6 == 'on',
      isSaturdayEnabled: api.d7 == 'on',
      times: api.times.map((t) => ScheduleTime(
        time: t.t,
        isEnabled: t.e == 'on',
      )).toList(),
      zones: api.zones.map((z) => ScheduleZone(
        duration: Duration(minutes: z.duration),
        isEnabled: z.e == 'on',
      )).toList(),
      nextRun: nextRun,
    );
  }

  static Schedule fromApiListItem(ApiScheduleListItem item) {
    return Schedule(
      id: item.id,
      name: item.name,
      isEnabled: item.e == 'on',
      isDayBased: true,  // Default values since list item doesn't have full info
      interval: 1,
      restriction: DayRestriction.none,
      isSundayEnabled: false,
      isMondayEnabled: false,
      isTuesdayEnabled: false,
      isWednesdayEnabled: false,
      isThursdayEnabled: false,
      isFridayEnabled: false,
      isSaturdayEnabled: false,
      times: [],
      zones: [],
      nextRun: item.next,
    );
  }
} 