// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SystemStateImpl _$$SystemStateImplFromJson(Map<String, dynamic> json) =>
    _$SystemStateImpl(
      version: json['version'] as String,
      isRunning: json['isRunning'] as bool,
      enabledZonesCount: (json['enabledZonesCount'] as num).toInt(),
      schedulesCount: (json['schedulesCount'] as num).toInt(),
      currentTime: DateTime.parse(json['currentTime'] as String),
      eventsCount: (json['eventsCount'] as num).toInt(),
      activeZoneName: json['activeZoneName'] as String?,
      remainingTime: json['remainingTime'] == null
          ? null
          : Duration(microseconds: (json['remainingTime'] as num).toInt()),
    );

Map<String, dynamic> _$$SystemStateImplToJson(_$SystemStateImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'isRunning': instance.isRunning,
      'enabledZonesCount': instance.enabledZonesCount,
      'schedulesCount': instance.schedulesCount,
      'currentTime': instance.currentTime.toIso8601String(),
      'eventsCount': instance.eventsCount,
      'activeZoneName': instance.activeZoneName,
      'remainingTime': instance.remainingTime?.inMicroseconds,
    };
