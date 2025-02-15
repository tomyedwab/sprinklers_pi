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
