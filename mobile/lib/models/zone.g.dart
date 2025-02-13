// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ZoneImpl _$$ZoneImplFromJson(Map<String, dynamic> json) => _$ZoneImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isEnabled: json['isEnabled'] as bool,
      isRunning: json['isRunning'] as bool,
      isPumpAssociated: json['isPumpAssociated'] as bool? ?? false,
      wateringTime: (json['wateringTime'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$ZoneImplToJson(_$ZoneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isEnabled': instance.isEnabled,
      'isRunning': instance.isRunning,
      'isPumpAssociated': instance.isPumpAssociated,
      'wateringTime': instance.wateringTime,
      'description': instance.description,
    };
