import 'package:freezed_annotation/freezed_annotation.dart';
import '../api/models/schedule.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

@freezed
class ScheduleListItem with _$ScheduleListItem {
  const ScheduleListItem._();  // This needs to come before the factory

  const factory ScheduleListItem({
    required int id,
    required String name,
    required bool isEnabled,
    String? nextRun,
  }) = _ScheduleListItem;

  String? get formattedNextRun {
    if (nextRun == null) return null;
    try {
      final time = DateTime.parse(nextRun!);
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return nextRun;
    }
  }
}

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
class ScheduleDetail with _$ScheduleDetail {
  const ScheduleDetail._();  // This needs to come before the factory

  const factory ScheduleDetail({
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
  }) = _ScheduleDetail;

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

  String get typeDisplay => isDayBased ? 'Daily' : 'Interval';
  
  String? get formattedNextRun {
    if (nextRun == null) return null;
    try {
      final time = DateTime.parse(nextRun!);
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return nextRun;
    }
  }

  String get scheduleDescription {
    if (isDayBased) {
      final days = <String>[];
      if (isSundayEnabled) days.add('Sun');
      if (isMondayEnabled) days.add('Mon');
      if (isTuesdayEnabled) days.add('Tue');
      if (isWednesdayEnabled) days.add('Wed');
      if (isThursdayEnabled) days.add('Thu');
      if (isFridayEnabled) days.add('Fri');
      if (isSaturdayEnabled) days.add('Sat');
      return days.join(', ');
    } else {
      return 'Every $interval days';
    }
  }

  String get restrictionText {
    switch (restriction) {
      case DayRestriction.none:
        return '';
      case DayRestriction.oddDays:
        return 'Odd days only';
      case DayRestriction.evenDays:
        return 'Even days only';
    }
  }
}

extension ApiScheduleX on ScheduleDetail {
  static ScheduleDetail fromApiSchedule(int id, ApiScheduleDetail api, {String? nextRun}) {
    return ScheduleDetail(
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
}

extension ApiScheduleListX on ScheduleListItem {
  static ScheduleListItem fromApiListItem(ApiScheduleListItem item) {
    return ScheduleListItem(
      id: item.id,
      name: item.name,
      isEnabled: item.e == 'on',
      nextRun: item.next,
    );
  }
} 