// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SystemState _$SystemStateFromJson(Map<String, dynamic> json) {
  return _SystemState.fromJson(json);
}

/// @nodoc
mixin _$SystemState {
  String get version => throw _privateConstructorUsedError;
  bool get isRunning => throw _privateConstructorUsedError;
  int get enabledZonesCount => throw _privateConstructorUsedError;
  int get schedulesCount => throw _privateConstructorUsedError;
  DateTime get currentTime => throw _privateConstructorUsedError;
  int get eventsCount => throw _privateConstructorUsedError;
  String? get activeZoneName => throw _privateConstructorUsedError;
  Duration? get remainingTime => throw _privateConstructorUsedError;

  /// Serializes this SystemState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SystemState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SystemStateCopyWith<SystemState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemStateCopyWith<$Res> {
  factory $SystemStateCopyWith(
          SystemState value, $Res Function(SystemState) then) =
      _$SystemStateCopyWithImpl<$Res, SystemState>;
  @useResult
  $Res call(
      {String version,
      bool isRunning,
      int enabledZonesCount,
      int schedulesCount,
      DateTime currentTime,
      int eventsCount,
      String? activeZoneName,
      Duration? remainingTime});
}

/// @nodoc
class _$SystemStateCopyWithImpl<$Res, $Val extends SystemState>
    implements $SystemStateCopyWith<$Res> {
  _$SystemStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SystemState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? isRunning = null,
    Object? enabledZonesCount = null,
    Object? schedulesCount = null,
    Object? currentTime = null,
    Object? eventsCount = null,
    Object? activeZoneName = freezed,
    Object? remainingTime = freezed,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      isRunning: null == isRunning
          ? _value.isRunning
          : isRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      enabledZonesCount: null == enabledZonesCount
          ? _value.enabledZonesCount
          : enabledZonesCount // ignore: cast_nullable_to_non_nullable
              as int,
      schedulesCount: null == schedulesCount
          ? _value.schedulesCount
          : schedulesCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentTime: null == currentTime
          ? _value.currentTime
          : currentTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      eventsCount: null == eventsCount
          ? _value.eventsCount
          : eventsCount // ignore: cast_nullable_to_non_nullable
              as int,
      activeZoneName: freezed == activeZoneName
          ? _value.activeZoneName
          : activeZoneName // ignore: cast_nullable_to_non_nullable
              as String?,
      remainingTime: freezed == remainingTime
          ? _value.remainingTime
          : remainingTime // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SystemStateImplCopyWith<$Res>
    implements $SystemStateCopyWith<$Res> {
  factory _$$SystemStateImplCopyWith(
          _$SystemStateImpl value, $Res Function(_$SystemStateImpl) then) =
      __$$SystemStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String version,
      bool isRunning,
      int enabledZonesCount,
      int schedulesCount,
      DateTime currentTime,
      int eventsCount,
      String? activeZoneName,
      Duration? remainingTime});
}

/// @nodoc
class __$$SystemStateImplCopyWithImpl<$Res>
    extends _$SystemStateCopyWithImpl<$Res, _$SystemStateImpl>
    implements _$$SystemStateImplCopyWith<$Res> {
  __$$SystemStateImplCopyWithImpl(
      _$SystemStateImpl _value, $Res Function(_$SystemStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SystemState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? isRunning = null,
    Object? enabledZonesCount = null,
    Object? schedulesCount = null,
    Object? currentTime = null,
    Object? eventsCount = null,
    Object? activeZoneName = freezed,
    Object? remainingTime = freezed,
  }) {
    return _then(_$SystemStateImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      isRunning: null == isRunning
          ? _value.isRunning
          : isRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      enabledZonesCount: null == enabledZonesCount
          ? _value.enabledZonesCount
          : enabledZonesCount // ignore: cast_nullable_to_non_nullable
              as int,
      schedulesCount: null == schedulesCount
          ? _value.schedulesCount
          : schedulesCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentTime: null == currentTime
          ? _value.currentTime
          : currentTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      eventsCount: null == eventsCount
          ? _value.eventsCount
          : eventsCount // ignore: cast_nullable_to_non_nullable
              as int,
      activeZoneName: freezed == activeZoneName
          ? _value.activeZoneName
          : activeZoneName // ignore: cast_nullable_to_non_nullable
              as String?,
      remainingTime: freezed == remainingTime
          ? _value.remainingTime
          : remainingTime // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SystemStateImpl implements _SystemState {
  const _$SystemStateImpl(
      {required this.version,
      required this.isRunning,
      required this.enabledZonesCount,
      required this.schedulesCount,
      required this.currentTime,
      required this.eventsCount,
      this.activeZoneName,
      this.remainingTime});

  factory _$SystemStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemStateImplFromJson(json);

  @override
  final String version;
  @override
  final bool isRunning;
  @override
  final int enabledZonesCount;
  @override
  final int schedulesCount;
  @override
  final DateTime currentTime;
  @override
  final int eventsCount;
  @override
  final String? activeZoneName;
  @override
  final Duration? remainingTime;

  @override
  String toString() {
    return 'SystemState(version: $version, isRunning: $isRunning, enabledZonesCount: $enabledZonesCount, schedulesCount: $schedulesCount, currentTime: $currentTime, eventsCount: $eventsCount, activeZoneName: $activeZoneName, remainingTime: $remainingTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemStateImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.isRunning, isRunning) ||
                other.isRunning == isRunning) &&
            (identical(other.enabledZonesCount, enabledZonesCount) ||
                other.enabledZonesCount == enabledZonesCount) &&
            (identical(other.schedulesCount, schedulesCount) ||
                other.schedulesCount == schedulesCount) &&
            (identical(other.currentTime, currentTime) ||
                other.currentTime == currentTime) &&
            (identical(other.eventsCount, eventsCount) ||
                other.eventsCount == eventsCount) &&
            (identical(other.activeZoneName, activeZoneName) ||
                other.activeZoneName == activeZoneName) &&
            (identical(other.remainingTime, remainingTime) ||
                other.remainingTime == remainingTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      version,
      isRunning,
      enabledZonesCount,
      schedulesCount,
      currentTime,
      eventsCount,
      activeZoneName,
      remainingTime);

  /// Create a copy of SystemState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemStateImplCopyWith<_$SystemStateImpl> get copyWith =>
      __$$SystemStateImplCopyWithImpl<_$SystemStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SystemStateImplToJson(
      this,
    );
  }
}

abstract class _SystemState implements SystemState {
  const factory _SystemState(
      {required final String version,
      required final bool isRunning,
      required final int enabledZonesCount,
      required final int schedulesCount,
      required final DateTime currentTime,
      required final int eventsCount,
      final String? activeZoneName,
      final Duration? remainingTime}) = _$SystemStateImpl;

  factory _SystemState.fromJson(Map<String, dynamic> json) =
      _$SystemStateImpl.fromJson;

  @override
  String get version;
  @override
  bool get isRunning;
  @override
  int get enabledZonesCount;
  @override
  int get schedulesCount;
  @override
  DateTime get currentTime;
  @override
  int get eventsCount;
  @override
  String? get activeZoneName;
  @override
  Duration? get remainingTime;

  /// Create a copy of SystemState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SystemStateImplCopyWith<_$SystemStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
