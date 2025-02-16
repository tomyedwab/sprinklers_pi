import 'package:freezed_annotation/freezed_annotation.dart';
import '../api/models/schedule.dart';

part 'schedule.freezed.dart';

enum ScheduleType {
  dayBased,
  intervalBased,
}

enum DayRestriction {
  none,
  oddDays,
  evenDays,
}

@freezed
class ScheduleTime with _$ScheduleTime {
  const factory ScheduleTime({
    required String time,  // HH:MM format
    required bool isEnabled,
  }) = _ScheduleTime;

  const ScheduleTime._();
}

@freezed
class ScheduleZone with _$ScheduleZone {
  const factory ScheduleZone({
    required int duration,  // Minutes
    required bool isEnabled,
  }) = _ScheduleZone;

  const ScheduleZone._();
}

@freezed
class ScheduleListItem with _$ScheduleListItem {
  const factory ScheduleListItem({
    required int id,
    required String name,
    required bool isEnabled,
    required String nextRun,
  }) = _ScheduleListItem;

  const ScheduleListItem._();
}

@freezed
class ScheduleDetail with _$ScheduleDetail {
  const factory ScheduleDetail({
    required String name,
    required bool isEnabled,
    required ScheduleType type,
    required int interval,  // Days between runs (1-20)
    required DayRestriction restriction,
    required bool isWeatherAdjusted,
    required List<bool> days,  // Sunday to Saturday
    required List<ScheduleTime> times,
    required List<ScheduleZone> zones,
    @Default(null) int? id,  // Nullable ID, null for new schedules
  }) = _ScheduleDetail;

  const ScheduleDetail._();

  // Computed properties for day access
  bool get isSundayEnabled => days[0];
  bool get isMondayEnabled => days[1];
  bool get isTuesdayEnabled => days[2];
  bool get isWednesdayEnabled => days[3];
  bool get isThursdayEnabled => days[4];
  bool get isFridayEnabled => days[5];
  bool get isSaturdayEnabled => days[6];
  bool get isDayBased => type == ScheduleType.dayBased;
}

extension ApiScheduleListItemX on ApiScheduleListItem {
  ScheduleListItem toModel() {
    return ScheduleListItem(
      id: id,
      name: name,
      isEnabled: e == 'on',
      nextRun: next,
    );
  }
}

extension ApiScheduleDetailX on ApiScheduleDetail {
  ScheduleDetail toModel() {
    return ScheduleDetail(
      name: name,
      isEnabled: enabled == 'on',
      type: type == 'on' ? ScheduleType.dayBased : ScheduleType.intervalBased,
      interval: int.parse(interval),  // Convert string to int
      restriction: switch (restrict) {
        '0' => DayRestriction.none,
        '1' => DayRestriction.oddDays,
        '2' => DayRestriction.evenDays,
        _ => DayRestriction.none,
      },
      isWeatherAdjusted: wadj == 'on',
      days: [d1, d2, d3, d4, d5, d6, d7].map((d) => d == 'on').toList(),
      times: times.map((t) => ScheduleTime(
        time: t.t,
        isEnabled: t.e == 'on',
      )).toList(),
      zones: zones.map((z) => ScheduleZone(
        duration: z.duration,
        isEnabled: z.e == 'on',
      )).toList(),
    );
  }
}

extension ScheduleDetailX on ScheduleDetail {
  Map<String, String> toApiParams() {
    final params = <String, String>{
      if (id != null) 'id': id.toString(),  // Only include ID if it exists
      'name': name,
      'enable': isEnabled ? 'on' : 'off',
      'type': isDayBased ? 'on' : 'off',
      'interval': interval.toString(),  // Convert int back to string
      'restrict': switch (restriction) {
        DayRestriction.none => '0',
        DayRestriction.oddDays => '1',
        DayRestriction.evenDays => '2',
      },
      'wadj': isWeatherAdjusted ? 'on' : 'off',
    };

    // Add days
    for (var i = 0; i < days.length; i++) {
      params['d${i + 1}'] = days[i] ? 'on' : 'off';
    }

    // Add times
    for (var i = 0; i < times.length; i++) {
      params['t${i + 1}'] = times[i].time;
      params['e${i + 1}'] = times[i].isEnabled ? 'on' : 'off';
    }

    // Add zones
    for (var i = 0; i < zones.length; i++) {
      final zoneId = String.fromCharCode('b'.codeUnitAt(0) + i);
      params['z$zoneId'] = zones[i].duration.toString();
    }

    return params;
  }
}

extension ScheduleListItemX on ScheduleListItem {
  String? get formattedNextRun => nextRun.isEmpty ? null : nextRun;
} 