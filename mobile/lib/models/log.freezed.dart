// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LogEntry {
  DateTime get date => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  int get scheduleId =>
      throw _privateConstructorUsedError; // -1=Manual, 100=Quick
  int get seasonalAdjustment => throw _privateConstructorUsedError;
  int get weatherAdjustment => throw _privateConstructorUsedError;

  /// Create a copy of LogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogEntryCopyWith<LogEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogEntryCopyWith<$Res> {
  factory $LogEntryCopyWith(LogEntry value, $Res Function(LogEntry) then) =
      _$LogEntryCopyWithImpl<$Res, LogEntry>;
  @useResult
  $Res call(
      {DateTime date,
      Duration duration,
      int scheduleId,
      int seasonalAdjustment,
      int weatherAdjustment});
}

/// @nodoc
class _$LogEntryCopyWithImpl<$Res, $Val extends LogEntry>
    implements $LogEntryCopyWith<$Res> {
  _$LogEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? duration = null,
    Object? scheduleId = null,
    Object? seasonalAdjustment = null,
    Object? weatherAdjustment = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      seasonalAdjustment: null == seasonalAdjustment
          ? _value.seasonalAdjustment
          : seasonalAdjustment // ignore: cast_nullable_to_non_nullable
              as int,
      weatherAdjustment: null == weatherAdjustment
          ? _value.weatherAdjustment
          : weatherAdjustment // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LogEntryImplCopyWith<$Res>
    implements $LogEntryCopyWith<$Res> {
  factory _$$LogEntryImplCopyWith(
          _$LogEntryImpl value, $Res Function(_$LogEntryImpl) then) =
      __$$LogEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      Duration duration,
      int scheduleId,
      int seasonalAdjustment,
      int weatherAdjustment});
}

/// @nodoc
class __$$LogEntryImplCopyWithImpl<$Res>
    extends _$LogEntryCopyWithImpl<$Res, _$LogEntryImpl>
    implements _$$LogEntryImplCopyWith<$Res> {
  __$$LogEntryImplCopyWithImpl(
      _$LogEntryImpl _value, $Res Function(_$LogEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of LogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? duration = null,
    Object? scheduleId = null,
    Object? seasonalAdjustment = null,
    Object? weatherAdjustment = null,
  }) {
    return _then(_$LogEntryImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      seasonalAdjustment: null == seasonalAdjustment
          ? _value.seasonalAdjustment
          : seasonalAdjustment // ignore: cast_nullable_to_non_nullable
              as int,
      weatherAdjustment: null == weatherAdjustment
          ? _value.weatherAdjustment
          : weatherAdjustment // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$LogEntryImpl extends _LogEntry {
  const _$LogEntryImpl(
      {required this.date,
      required this.duration,
      required this.scheduleId,
      required this.seasonalAdjustment,
      required this.weatherAdjustment})
      : super._();

  @override
  final DateTime date;
  @override
  final Duration duration;
  @override
  final int scheduleId;
// -1=Manual, 100=Quick
  @override
  final int seasonalAdjustment;
  @override
  final int weatherAdjustment;

  @override
  String toString() {
    return 'LogEntry(date: $date, duration: $duration, scheduleId: $scheduleId, seasonalAdjustment: $seasonalAdjustment, weatherAdjustment: $weatherAdjustment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogEntryImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.scheduleId, scheduleId) ||
                other.scheduleId == scheduleId) &&
            (identical(other.seasonalAdjustment, seasonalAdjustment) ||
                other.seasonalAdjustment == seasonalAdjustment) &&
            (identical(other.weatherAdjustment, weatherAdjustment) ||
                other.weatherAdjustment == weatherAdjustment));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, duration, scheduleId,
      seasonalAdjustment, weatherAdjustment);

  /// Create a copy of LogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogEntryImplCopyWith<_$LogEntryImpl> get copyWith =>
      __$$LogEntryImplCopyWithImpl<_$LogEntryImpl>(this, _$identity);
}

abstract class _LogEntry extends LogEntry {
  const factory _LogEntry(
      {required final DateTime date,
      required final Duration duration,
      required final int scheduleId,
      required final int seasonalAdjustment,
      required final int weatherAdjustment}) = _$LogEntryImpl;
  const _LogEntry._() : super._();

  @override
  DateTime get date;
  @override
  Duration get duration;
  @override
  int get scheduleId; // -1=Manual, 100=Quick
  @override
  int get seasonalAdjustment;
  @override
  int get weatherAdjustment;

  /// Create a copy of LogEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogEntryImplCopyWith<_$LogEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ZoneLog {
  int get zoneId => throw _privateConstructorUsedError;
  List<LogEntry> get entries => throw _privateConstructorUsedError;

  /// Create a copy of ZoneLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ZoneLogCopyWith<ZoneLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ZoneLogCopyWith<$Res> {
  factory $ZoneLogCopyWith(ZoneLog value, $Res Function(ZoneLog) then) =
      _$ZoneLogCopyWithImpl<$Res, ZoneLog>;
  @useResult
  $Res call({int zoneId, List<LogEntry> entries});
}

/// @nodoc
class _$ZoneLogCopyWithImpl<$Res, $Val extends ZoneLog>
    implements $ZoneLogCopyWith<$Res> {
  _$ZoneLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ZoneLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? zoneId = null,
    Object? entries = null,
  }) {
    return _then(_value.copyWith(
      zoneId: null == zoneId
          ? _value.zoneId
          : zoneId // ignore: cast_nullable_to_non_nullable
              as int,
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<LogEntry>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ZoneLogImplCopyWith<$Res> implements $ZoneLogCopyWith<$Res> {
  factory _$$ZoneLogImplCopyWith(
          _$ZoneLogImpl value, $Res Function(_$ZoneLogImpl) then) =
      __$$ZoneLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int zoneId, List<LogEntry> entries});
}

/// @nodoc
class __$$ZoneLogImplCopyWithImpl<$Res>
    extends _$ZoneLogCopyWithImpl<$Res, _$ZoneLogImpl>
    implements _$$ZoneLogImplCopyWith<$Res> {
  __$$ZoneLogImplCopyWithImpl(
      _$ZoneLogImpl _value, $Res Function(_$ZoneLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of ZoneLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? zoneId = null,
    Object? entries = null,
  }) {
    return _then(_$ZoneLogImpl(
      zoneId: null == zoneId
          ? _value.zoneId
          : zoneId // ignore: cast_nullable_to_non_nullable
              as int,
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<LogEntry>,
    ));
  }
}

/// @nodoc

class _$ZoneLogImpl extends _ZoneLog {
  const _$ZoneLogImpl(
      {required this.zoneId, required final List<LogEntry> entries})
      : _entries = entries,
        super._();

  @override
  final int zoneId;
  final List<LogEntry> _entries;
  @override
  List<LogEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  String toString() {
    return 'ZoneLog(zoneId: $zoneId, entries: $entries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ZoneLogImpl &&
            (identical(other.zoneId, zoneId) || other.zoneId == zoneId) &&
            const DeepCollectionEquality().equals(other._entries, _entries));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, zoneId, const DeepCollectionEquality().hash(_entries));

  /// Create a copy of ZoneLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ZoneLogImplCopyWith<_$ZoneLogImpl> get copyWith =>
      __$$ZoneLogImplCopyWithImpl<_$ZoneLogImpl>(this, _$identity);
}

abstract class _ZoneLog extends ZoneLog {
  const factory _ZoneLog(
      {required final int zoneId,
      required final List<LogEntry> entries}) = _$ZoneLogImpl;
  const _ZoneLog._() : super._();

  @override
  int get zoneId;
  @override
  List<LogEntry> get entries;

  /// Create a copy of ZoneLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ZoneLogImplCopyWith<_$ZoneLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GraphPoint {
  DateTime get timestamp => throw _privateConstructorUsedError;
  Duration get value => throw _privateConstructorUsedError;

  /// Create a copy of GraphPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GraphPointCopyWith<GraphPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphPointCopyWith<$Res> {
  factory $GraphPointCopyWith(
          GraphPoint value, $Res Function(GraphPoint) then) =
      _$GraphPointCopyWithImpl<$Res, GraphPoint>;
  @useResult
  $Res call({DateTime timestamp, Duration value});
}

/// @nodoc
class _$GraphPointCopyWithImpl<$Res, $Val extends GraphPoint>
    implements $GraphPointCopyWith<$Res> {
  _$GraphPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GraphPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as Duration,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GraphPointImplCopyWith<$Res>
    implements $GraphPointCopyWith<$Res> {
  factory _$$GraphPointImplCopyWith(
          _$GraphPointImpl value, $Res Function(_$GraphPointImpl) then) =
      __$$GraphPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime timestamp, Duration value});
}

/// @nodoc
class __$$GraphPointImplCopyWithImpl<$Res>
    extends _$GraphPointCopyWithImpl<$Res, _$GraphPointImpl>
    implements _$$GraphPointImplCopyWith<$Res> {
  __$$GraphPointImplCopyWithImpl(
      _$GraphPointImpl _value, $Res Function(_$GraphPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of GraphPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? value = null,
  }) {
    return _then(_$GraphPointImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc

class _$GraphPointImpl implements _GraphPoint {
  const _$GraphPointImpl({required this.timestamp, required this.value});

  @override
  final DateTime timestamp;
  @override
  final Duration value;

  @override
  String toString() {
    return 'GraphPoint(timestamp: $timestamp, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphPointImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, timestamp, value);

  /// Create a copy of GraphPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphPointImplCopyWith<_$GraphPointImpl> get copyWith =>
      __$$GraphPointImplCopyWithImpl<_$GraphPointImpl>(this, _$identity);
}

abstract class _GraphPoint implements GraphPoint {
  const factory _GraphPoint(
      {required final DateTime timestamp,
      required final Duration value}) = _$GraphPointImpl;

  @override
  DateTime get timestamp;
  @override
  Duration get value;

  /// Create a copy of GraphPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GraphPointImplCopyWith<_$GraphPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
