// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zone.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Zone _$ZoneFromJson(Map<String, dynamic> json) {
  return _Zone.fromJson(json);
}

/// @nodoc
mixin _$Zone {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  bool get isRunning => throw _privateConstructorUsedError;
  bool get isPumpAssociated => throw _privateConstructorUsedError;
  int get wateringTime => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this Zone to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Zone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ZoneCopyWith<Zone> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ZoneCopyWith<$Res> {
  factory $ZoneCopyWith(Zone value, $Res Function(Zone) then) =
      _$ZoneCopyWithImpl<$Res, Zone>;
  @useResult
  $Res call(
      {int id,
      String name,
      bool isEnabled,
      bool isRunning,
      bool isPumpAssociated,
      int wateringTime,
      String? description});
}

/// @nodoc
class _$ZoneCopyWithImpl<$Res, $Val extends Zone>
    implements $ZoneCopyWith<$Res> {
  _$ZoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Zone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isEnabled = null,
    Object? isRunning = null,
    Object? isPumpAssociated = null,
    Object? wateringTime = null,
    Object? description = freezed,
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
      isRunning: null == isRunning
          ? _value.isRunning
          : isRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      isPumpAssociated: null == isPumpAssociated
          ? _value.isPumpAssociated
          : isPumpAssociated // ignore: cast_nullable_to_non_nullable
              as bool,
      wateringTime: null == wateringTime
          ? _value.wateringTime
          : wateringTime // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ZoneImplCopyWith<$Res> implements $ZoneCopyWith<$Res> {
  factory _$$ZoneImplCopyWith(
          _$ZoneImpl value, $Res Function(_$ZoneImpl) then) =
      __$$ZoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      bool isEnabled,
      bool isRunning,
      bool isPumpAssociated,
      int wateringTime,
      String? description});
}

/// @nodoc
class __$$ZoneImplCopyWithImpl<$Res>
    extends _$ZoneCopyWithImpl<$Res, _$ZoneImpl>
    implements _$$ZoneImplCopyWith<$Res> {
  __$$ZoneImplCopyWithImpl(_$ZoneImpl _value, $Res Function(_$ZoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of Zone
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isEnabled = null,
    Object? isRunning = null,
    Object? isPumpAssociated = null,
    Object? wateringTime = null,
    Object? description = freezed,
  }) {
    return _then(_$ZoneImpl(
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
      isRunning: null == isRunning
          ? _value.isRunning
          : isRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      isPumpAssociated: null == isPumpAssociated
          ? _value.isPumpAssociated
          : isPumpAssociated // ignore: cast_nullable_to_non_nullable
              as bool,
      wateringTime: null == wateringTime
          ? _value.wateringTime
          : wateringTime // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ZoneImpl implements _Zone {
  const _$ZoneImpl(
      {required this.id,
      required this.name,
      required this.isEnabled,
      required this.isRunning,
      this.isPumpAssociated = false,
      this.wateringTime = 0,
      this.description});

  factory _$ZoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$ZoneImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final bool isEnabled;
  @override
  final bool isRunning;
  @override
  @JsonKey()
  final bool isPumpAssociated;
  @override
  @JsonKey()
  final int wateringTime;
  @override
  final String? description;

  @override
  String toString() {
    return 'Zone(id: $id, name: $name, isEnabled: $isEnabled, isRunning: $isRunning, isPumpAssociated: $isPumpAssociated, wateringTime: $wateringTime, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ZoneImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.isRunning, isRunning) ||
                other.isRunning == isRunning) &&
            (identical(other.isPumpAssociated, isPumpAssociated) ||
                other.isPumpAssociated == isPumpAssociated) &&
            (identical(other.wateringTime, wateringTime) ||
                other.wateringTime == wateringTime) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, isEnabled, isRunning,
      isPumpAssociated, wateringTime, description);

  /// Create a copy of Zone
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ZoneImplCopyWith<_$ZoneImpl> get copyWith =>
      __$$ZoneImplCopyWithImpl<_$ZoneImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ZoneImplToJson(
      this,
    );
  }
}

abstract class _Zone implements Zone {
  const factory _Zone(
      {required final int id,
      required final String name,
      required final bool isEnabled,
      required final bool isRunning,
      final bool isPumpAssociated,
      final int wateringTime,
      final String? description}) = _$ZoneImpl;

  factory _Zone.fromJson(Map<String, dynamic> json) = _$ZoneImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  bool get isEnabled;
  @override
  bool get isRunning;
  @override
  bool get isPumpAssociated;
  @override
  int get wateringTime;
  @override
  String? get description;

  /// Create a copy of Zone
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ZoneImplCopyWith<_$ZoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
