// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScheduleTime _$ScheduleTimeFromJson(Map<String, dynamic> json) {
  return _ScheduleTime.fromJson(json);
}

/// @nodoc
mixin _$ScheduleTime {
  String get time => throw _privateConstructorUsedError; // HH:MM format
  bool get isEnabled => throw _privateConstructorUsedError;

  /// Serializes this ScheduleTime to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleTimeCopyWith<ScheduleTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleTimeCopyWith<$Res> {
  factory $ScheduleTimeCopyWith(
          ScheduleTime value, $Res Function(ScheduleTime) then) =
      _$ScheduleTimeCopyWithImpl<$Res, ScheduleTime>;
  @useResult
  $Res call({String time, bool isEnabled});
}

/// @nodoc
class _$ScheduleTimeCopyWithImpl<$Res, $Val extends ScheduleTime>
    implements $ScheduleTimeCopyWith<$Res> {
  _$ScheduleTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? isEnabled = null,
  }) {
    return _then(_value.copyWith(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleTimeImplCopyWith<$Res>
    implements $ScheduleTimeCopyWith<$Res> {
  factory _$$ScheduleTimeImplCopyWith(
          _$ScheduleTimeImpl value, $Res Function(_$ScheduleTimeImpl) then) =
      __$$ScheduleTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String time, bool isEnabled});
}

/// @nodoc
class __$$ScheduleTimeImplCopyWithImpl<$Res>
    extends _$ScheduleTimeCopyWithImpl<$Res, _$ScheduleTimeImpl>
    implements _$$ScheduleTimeImplCopyWith<$Res> {
  __$$ScheduleTimeImplCopyWithImpl(
      _$ScheduleTimeImpl _value, $Res Function(_$ScheduleTimeImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? isEnabled = null,
  }) {
    return _then(_$ScheduleTimeImpl(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleTimeImpl implements _ScheduleTime {
  const _$ScheduleTimeImpl({required this.time, required this.isEnabled});

  factory _$ScheduleTimeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleTimeImplFromJson(json);

  @override
  final String time;
// HH:MM format
  @override
  final bool isEnabled;

  @override
  String toString() {
    return 'ScheduleTime(time: $time, isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleTimeImpl &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, time, isEnabled);

  /// Create a copy of ScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleTimeImplCopyWith<_$ScheduleTimeImpl> get copyWith =>
      __$$ScheduleTimeImplCopyWithImpl<_$ScheduleTimeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleTimeImplToJson(
      this,
    );
  }
}

abstract class _ScheduleTime implements ScheduleTime {
  const factory _ScheduleTime(
      {required final String time,
      required final bool isEnabled}) = _$ScheduleTimeImpl;

  factory _ScheduleTime.fromJson(Map<String, dynamic> json) =
      _$ScheduleTimeImpl.fromJson;

  @override
  String get time; // HH:MM format
  @override
  bool get isEnabled;

  /// Create a copy of ScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleTimeImplCopyWith<_$ScheduleTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScheduleZone _$ScheduleZoneFromJson(Map<String, dynamic> json) {
  return _ScheduleZone.fromJson(json);
}

/// @nodoc
mixin _$ScheduleZone {
  Duration get duration => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;

  /// Serializes this ScheduleZone to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleZone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleZoneCopyWith<ScheduleZone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleZoneCopyWith<$Res> {
  factory $ScheduleZoneCopyWith(
          ScheduleZone value, $Res Function(ScheduleZone) then) =
      _$ScheduleZoneCopyWithImpl<$Res, ScheduleZone>;
  @useResult
  $Res call({Duration duration, bool isEnabled});
}

/// @nodoc
class _$ScheduleZoneCopyWithImpl<$Res, $Val extends ScheduleZone>
    implements $ScheduleZoneCopyWith<$Res> {
  _$ScheduleZoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleZone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? isEnabled = null,
  }) {
    return _then(_value.copyWith(
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleZoneImplCopyWith<$Res>
    implements $ScheduleZoneCopyWith<$Res> {
  factory _$$ScheduleZoneImplCopyWith(
          _$ScheduleZoneImpl value, $Res Function(_$ScheduleZoneImpl) then) =
      __$$ScheduleZoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Duration duration, bool isEnabled});
}

/// @nodoc
class __$$ScheduleZoneImplCopyWithImpl<$Res>
    extends _$ScheduleZoneCopyWithImpl<$Res, _$ScheduleZoneImpl>
    implements _$$ScheduleZoneImplCopyWith<$Res> {
  __$$ScheduleZoneImplCopyWithImpl(
      _$ScheduleZoneImpl _value, $Res Function(_$ScheduleZoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScheduleZone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? isEnabled = null,
  }) {
    return _then(_$ScheduleZoneImpl(
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleZoneImpl implements _ScheduleZone {
  const _$ScheduleZoneImpl({required this.duration, required this.isEnabled});

  factory _$ScheduleZoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleZoneImplFromJson(json);

  @override
  final Duration duration;
  @override
  final bool isEnabled;

  @override
  String toString() {
    return 'ScheduleZone(duration: $duration, isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleZoneImpl &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, duration, isEnabled);

  /// Create a copy of ScheduleZone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleZoneImplCopyWith<_$ScheduleZoneImpl> get copyWith =>
      __$$ScheduleZoneImplCopyWithImpl<_$ScheduleZoneImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleZoneImplToJson(
      this,
    );
  }
}

abstract class _ScheduleZone implements ScheduleZone {
  const factory _ScheduleZone(
      {required final Duration duration,
      required final bool isEnabled}) = _$ScheduleZoneImpl;

  factory _ScheduleZone.fromJson(Map<String, dynamic> json) =
      _$ScheduleZoneImpl.fromJson;

  @override
  Duration get duration;
  @override
  bool get isEnabled;

  /// Create a copy of ScheduleZone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleZoneImplCopyWith<_$ScheduleZoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Schedule _$ScheduleFromJson(Map<String, dynamic> json) {
  return _Schedule.fromJson(json);
}

/// @nodoc
mixin _$Schedule {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  bool get isDayBased =>
      throw _privateConstructorUsedError; // true = day-based, false = interval-based
  int get interval =>
      throw _privateConstructorUsedError; // Days between runs (1-20)
  DayRestriction get restriction => throw _privateConstructorUsedError;
  bool get isSundayEnabled => throw _privateConstructorUsedError;
  bool get isMondayEnabled => throw _privateConstructorUsedError;
  bool get isTuesdayEnabled => throw _privateConstructorUsedError;
  bool get isWednesdayEnabled => throw _privateConstructorUsedError;
  bool get isThursdayEnabled => throw _privateConstructorUsedError;
  bool get isFridayEnabled => throw _privateConstructorUsedError;
  bool get isSaturdayEnabled => throw _privateConstructorUsedError;
  List<ScheduleTime> get times => throw _privateConstructorUsedError;
  List<ScheduleZone> get zones => throw _privateConstructorUsedError;
  String? get nextRun => throw _privateConstructorUsedError;

  /// Serializes this Schedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleCopyWith<Schedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleCopyWith<$Res> {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) then) =
      _$ScheduleCopyWithImpl<$Res, Schedule>;
  @useResult
  $Res call(
      {int id,
      String name,
      bool isEnabled,
      bool isDayBased,
      int interval,
      DayRestriction restriction,
      bool isSundayEnabled,
      bool isMondayEnabled,
      bool isTuesdayEnabled,
      bool isWednesdayEnabled,
      bool isThursdayEnabled,
      bool isFridayEnabled,
      bool isSaturdayEnabled,
      List<ScheduleTime> times,
      List<ScheduleZone> zones,
      String? nextRun});
}

/// @nodoc
class _$ScheduleCopyWithImpl<$Res, $Val extends Schedule>
    implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isEnabled = null,
    Object? isDayBased = null,
    Object? interval = null,
    Object? restriction = null,
    Object? isSundayEnabled = null,
    Object? isMondayEnabled = null,
    Object? isTuesdayEnabled = null,
    Object? isWednesdayEnabled = null,
    Object? isThursdayEnabled = null,
    Object? isFridayEnabled = null,
    Object? isSaturdayEnabled = null,
    Object? times = null,
    Object? zones = null,
    Object? nextRun = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isDayBased: null == isDayBased
          ? _value.isDayBased
          : isDayBased // ignore: cast_nullable_to_non_nullable
              as bool,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      restriction: null == restriction
          ? _value.restriction
          : restriction // ignore: cast_nullable_to_non_nullable
              as DayRestriction,
      isSundayEnabled: null == isSundayEnabled
          ? _value.isSundayEnabled
          : isSundayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isMondayEnabled: null == isMondayEnabled
          ? _value.isMondayEnabled
          : isMondayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isTuesdayEnabled: null == isTuesdayEnabled
          ? _value.isTuesdayEnabled
          : isTuesdayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isWednesdayEnabled: null == isWednesdayEnabled
          ? _value.isWednesdayEnabled
          : isWednesdayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isThursdayEnabled: null == isThursdayEnabled
          ? _value.isThursdayEnabled
          : isThursdayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isFridayEnabled: null == isFridayEnabled
          ? _value.isFridayEnabled
          : isFridayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaturdayEnabled: null == isSaturdayEnabled
          ? _value.isSaturdayEnabled
          : isSaturdayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      times: null == times
          ? _value.times
          : times // ignore: cast_nullable_to_non_nullable
              as List<ScheduleTime>,
      zones: null == zones
          ? _value.zones
          : zones // ignore: cast_nullable_to_non_nullable
              as List<ScheduleZone>,
      nextRun: freezed == nextRun
          ? _value.nextRun
          : nextRun // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleImplCopyWith<$Res>
    implements $ScheduleCopyWith<$Res> {
  factory _$$ScheduleImplCopyWith(
          _$ScheduleImpl value, $Res Function(_$ScheduleImpl) then) =
      __$$ScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      bool isEnabled,
      bool isDayBased,
      int interval,
      DayRestriction restriction,
      bool isSundayEnabled,
      bool isMondayEnabled,
      bool isTuesdayEnabled,
      bool isWednesdayEnabled,
      bool isThursdayEnabled,
      bool isFridayEnabled,
      bool isSaturdayEnabled,
      List<ScheduleTime> times,
      List<ScheduleZone> zones,
      String? nextRun});
}

/// @nodoc
class __$$ScheduleImplCopyWithImpl<$Res>
    extends _$ScheduleCopyWithImpl<$Res, _$ScheduleImpl>
    implements _$$ScheduleImplCopyWith<$Res> {
  __$$ScheduleImplCopyWithImpl(
      _$ScheduleImpl _value, $Res Function(_$ScheduleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isEnabled = null,
    Object? isDayBased = null,
    Object? interval = null,
    Object? restriction = null,
    Object? isSundayEnabled = null,
    Object? isMondayEnabled = null,
    Object? isTuesdayEnabled = null,
    Object? isWednesdayEnabled = null,
    Object? isThursdayEnabled = null,
    Object? isFridayEnabled = null,
    Object? isSaturdayEnabled = null,
    Object? times = null,
    Object? zones = null,
    Object? nextRun = freezed,
  }) {
    return _then(_$ScheduleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isDayBased: null == isDayBased
          ? _value.isDayBased
          : isDayBased // ignore: cast_nullable_to_non_nullable
              as bool,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      restriction: null == restriction
          ? _value.restriction
          : restriction // ignore: cast_nullable_to_non_nullable
              as DayRestriction,
      isSundayEnabled: null == isSundayEnabled
          ? _value.isSundayEnabled
          : isSundayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isMondayEnabled: null == isMondayEnabled
          ? _value.isMondayEnabled
          : isMondayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isTuesdayEnabled: null == isTuesdayEnabled
          ? _value.isTuesdayEnabled
          : isTuesdayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isWednesdayEnabled: null == isWednesdayEnabled
          ? _value.isWednesdayEnabled
          : isWednesdayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isThursdayEnabled: null == isThursdayEnabled
          ? _value.isThursdayEnabled
          : isThursdayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isFridayEnabled: null == isFridayEnabled
          ? _value.isFridayEnabled
          : isFridayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaturdayEnabled: null == isSaturdayEnabled
          ? _value.isSaturdayEnabled
          : isSaturdayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      times: null == times
          ? _value._times
          : times // ignore: cast_nullable_to_non_nullable
              as List<ScheduleTime>,
      zones: null == zones
          ? _value._zones
          : zones // ignore: cast_nullable_to_non_nullable
              as List<ScheduleZone>,
      nextRun: freezed == nextRun
          ? _value.nextRun
          : nextRun // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleImpl extends _Schedule {
  const _$ScheduleImpl(
      {required this.id,
      required this.name,
      required this.isEnabled,
      required this.isDayBased,
      required this.interval,
      required this.restriction,
      required this.isSundayEnabled,
      required this.isMondayEnabled,
      required this.isTuesdayEnabled,
      required this.isWednesdayEnabled,
      required this.isThursdayEnabled,
      required this.isFridayEnabled,
      required this.isSaturdayEnabled,
      required final List<ScheduleTime> times,
      required final List<ScheduleZone> zones,
      this.nextRun})
      : _times = times,
        _zones = zones,
        super._();

  factory _$ScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final bool isEnabled;
  @override
  final bool isDayBased;
// true = day-based, false = interval-based
  @override
  final int interval;
// Days between runs (1-20)
  @override
  final DayRestriction restriction;
  @override
  final bool isSundayEnabled;
  @override
  final bool isMondayEnabled;
  @override
  final bool isTuesdayEnabled;
  @override
  final bool isWednesdayEnabled;
  @override
  final bool isThursdayEnabled;
  @override
  final bool isFridayEnabled;
  @override
  final bool isSaturdayEnabled;
  final List<ScheduleTime> _times;
  @override
  List<ScheduleTime> get times {
    if (_times is EqualUnmodifiableListView) return _times;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_times);
  }

  final List<ScheduleZone> _zones;
  @override
  List<ScheduleZone> get zones {
    if (_zones is EqualUnmodifiableListView) return _zones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_zones);
  }

  @override
  final String? nextRun;

  @override
  String toString() {
    return 'Schedule(id: $id, name: $name, isEnabled: $isEnabled, isDayBased: $isDayBased, interval: $interval, restriction: $restriction, isSundayEnabled: $isSundayEnabled, isMondayEnabled: $isMondayEnabled, isTuesdayEnabled: $isTuesdayEnabled, isWednesdayEnabled: $isWednesdayEnabled, isThursdayEnabled: $isThursdayEnabled, isFridayEnabled: $isFridayEnabled, isSaturdayEnabled: $isSaturdayEnabled, times: $times, zones: $zones, nextRun: $nextRun)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.isDayBased, isDayBased) ||
                other.isDayBased == isDayBased) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.restriction, restriction) ||
                other.restriction == restriction) &&
            (identical(other.isSundayEnabled, isSundayEnabled) ||
                other.isSundayEnabled == isSundayEnabled) &&
            (identical(other.isMondayEnabled, isMondayEnabled) ||
                other.isMondayEnabled == isMondayEnabled) &&
            (identical(other.isTuesdayEnabled, isTuesdayEnabled) ||
                other.isTuesdayEnabled == isTuesdayEnabled) &&
            (identical(other.isWednesdayEnabled, isWednesdayEnabled) ||
                other.isWednesdayEnabled == isWednesdayEnabled) &&
            (identical(other.isThursdayEnabled, isThursdayEnabled) ||
                other.isThursdayEnabled == isThursdayEnabled) &&
            (identical(other.isFridayEnabled, isFridayEnabled) ||
                other.isFridayEnabled == isFridayEnabled) &&
            (identical(other.isSaturdayEnabled, isSaturdayEnabled) ||
                other.isSaturdayEnabled == isSaturdayEnabled) &&
            const DeepCollectionEquality().equals(other._times, _times) &&
            const DeepCollectionEquality().equals(other._zones, _zones) &&
            (identical(other.nextRun, nextRun) || other.nextRun == nextRun));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      isEnabled,
      isDayBased,
      interval,
      restriction,
      isSundayEnabled,
      isMondayEnabled,
      isTuesdayEnabled,
      isWednesdayEnabled,
      isThursdayEnabled,
      isFridayEnabled,
      isSaturdayEnabled,
      const DeepCollectionEquality().hash(_times),
      const DeepCollectionEquality().hash(_zones),
      nextRun);

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleImplCopyWith<_$ScheduleImpl> get copyWith =>
      __$$ScheduleImplCopyWithImpl<_$ScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleImplToJson(
      this,
    );
  }
}

abstract class _Schedule extends Schedule {
  const factory _Schedule(
      {required final int id,
      required final String name,
      required final bool isEnabled,
      required final bool isDayBased,
      required final int interval,
      required final DayRestriction restriction,
      required final bool isSundayEnabled,
      required final bool isMondayEnabled,
      required final bool isTuesdayEnabled,
      required final bool isWednesdayEnabled,
      required final bool isThursdayEnabled,
      required final bool isFridayEnabled,
      required final bool isSaturdayEnabled,
      required final List<ScheduleTime> times,
      required final List<ScheduleZone> zones,
      final String? nextRun}) = _$ScheduleImpl;
  const _Schedule._() : super._();

  factory _Schedule.fromJson(Map<String, dynamic> json) =
      _$ScheduleImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  bool get isEnabled;
  @override
  bool get isDayBased; // true = day-based, false = interval-based
  @override
  int get interval; // Days between runs (1-20)
  @override
  DayRestriction get restriction;
  @override
  bool get isSundayEnabled;
  @override
  bool get isMondayEnabled;
  @override
  bool get isTuesdayEnabled;
  @override
  bool get isWednesdayEnabled;
  @override
  bool get isThursdayEnabled;
  @override
  bool get isFridayEnabled;
  @override
  bool get isSaturdayEnabled;
  @override
  List<ScheduleTime> get times;
  @override
  List<ScheduleZone> get zones;
  @override
  String? get nextRun;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleImplCopyWith<_$ScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
