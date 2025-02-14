// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleTimeImpl _$$ScheduleTimeImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleTimeImpl(
      time: json['time'] as String,
      isEnabled: json['isEnabled'] as bool,
    );

Map<String, dynamic> _$$ScheduleTimeImplToJson(_$ScheduleTimeImpl instance) =>
    <String, dynamic>{
      'time': instance.time,
      'isEnabled': instance.isEnabled,
    };

_$ScheduleZoneImpl _$$ScheduleZoneImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleZoneImpl(
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      isEnabled: json['isEnabled'] as bool,
    );

Map<String, dynamic> _$$ScheduleZoneImplToJson(_$ScheduleZoneImpl instance) =>
    <String, dynamic>{
      'duration': instance.duration.inMicroseconds,
      'isEnabled': instance.isEnabled,
    };

_$ScheduleImpl _$$ScheduleImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isEnabled: json['isEnabled'] as bool,
      isDayBased: json['isDayBased'] as bool,
      interval: (json['interval'] as num).toInt(),
      restriction: $enumDecode(_$DayRestrictionEnumMap, json['restriction']),
      isSundayEnabled: json['isSundayEnabled'] as bool,
      isMondayEnabled: json['isMondayEnabled'] as bool,
      isTuesdayEnabled: json['isTuesdayEnabled'] as bool,
      isWednesdayEnabled: json['isWednesdayEnabled'] as bool,
      isThursdayEnabled: json['isThursdayEnabled'] as bool,
      isFridayEnabled: json['isFridayEnabled'] as bool,
      isSaturdayEnabled: json['isSaturdayEnabled'] as bool,
      times: (json['times'] as List<dynamic>)
          .map((e) => ScheduleTime.fromJson(e as Map<String, dynamic>))
          .toList(),
      zones: (json['zones'] as List<dynamic>)
          .map((e) => ScheduleZone.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextRun: json['nextRun'] as String?,
    );

Map<String, dynamic> _$$ScheduleImplToJson(_$ScheduleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isEnabled': instance.isEnabled,
      'isDayBased': instance.isDayBased,
      'interval': instance.interval,
      'restriction': _$DayRestrictionEnumMap[instance.restriction]!,
      'isSundayEnabled': instance.isSundayEnabled,
      'isMondayEnabled': instance.isMondayEnabled,
      'isTuesdayEnabled': instance.isTuesdayEnabled,
      'isWednesdayEnabled': instance.isWednesdayEnabled,
      'isThursdayEnabled': instance.isThursdayEnabled,
      'isFridayEnabled': instance.isFridayEnabled,
      'isSaturdayEnabled': instance.isSaturdayEnabled,
      'times': instance.times,
      'zones': instance.zones,
      'nextRun': instance.nextRun,
    };

const _$DayRestrictionEnumMap = {
  DayRestriction.none: 'none',
  DayRestriction.oddDays: 'oddDays',
  DayRestriction.evenDays: 'evenDays',
};
