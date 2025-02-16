// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Settings {
  int get webPort => throw _privateConstructorUsedError;
  OutputType get outputType => throw _privateConstructorUsedError;
  String get weatherServiceIp => throw _privateConstructorUsedError;
  String? get weatherApiSecret => throw _privateConstructorUsedError;
  String? get location =>
      throw _privateConstructorUsedError; // Format: "latitude,longitude"
  int get seasonalAdjustment => throw _privateConstructorUsedError;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsCopyWith<Settings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsCopyWith<$Res> {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) then) =
      _$SettingsCopyWithImpl<$Res, Settings>;
  @useResult
  $Res call(
      {int webPort,
      OutputType outputType,
      String weatherServiceIp,
      String? weatherApiSecret,
      String? location,
      int seasonalAdjustment});
}

/// @nodoc
class _$SettingsCopyWithImpl<$Res, $Val extends Settings>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? webPort = null,
    Object? outputType = null,
    Object? weatherServiceIp = null,
    Object? weatherApiSecret = freezed,
    Object? location = freezed,
    Object? seasonalAdjustment = null,
  }) {
    return _then(_value.copyWith(
      webPort: null == webPort
          ? _value.webPort
          : webPort // ignore: cast_nullable_to_non_nullable
              as int,
      outputType: null == outputType
          ? _value.outputType
          : outputType // ignore: cast_nullable_to_non_nullable
              as OutputType,
      weatherServiceIp: null == weatherServiceIp
          ? _value.weatherServiceIp
          : weatherServiceIp // ignore: cast_nullable_to_non_nullable
              as String,
      weatherApiSecret: freezed == weatherApiSecret
          ? _value.weatherApiSecret
          : weatherApiSecret // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      seasonalAdjustment: null == seasonalAdjustment
          ? _value.seasonalAdjustment
          : seasonalAdjustment // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingsImplCopyWith<$Res>
    implements $SettingsCopyWith<$Res> {
  factory _$$SettingsImplCopyWith(
          _$SettingsImpl value, $Res Function(_$SettingsImpl) then) =
      __$$SettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int webPort,
      OutputType outputType,
      String weatherServiceIp,
      String? weatherApiSecret,
      String? location,
      int seasonalAdjustment});
}

/// @nodoc
class __$$SettingsImplCopyWithImpl<$Res>
    extends _$SettingsCopyWithImpl<$Res, _$SettingsImpl>
    implements _$$SettingsImplCopyWith<$Res> {
  __$$SettingsImplCopyWithImpl(
      _$SettingsImpl _value, $Res Function(_$SettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? webPort = null,
    Object? outputType = null,
    Object? weatherServiceIp = null,
    Object? weatherApiSecret = freezed,
    Object? location = freezed,
    Object? seasonalAdjustment = null,
  }) {
    return _then(_$SettingsImpl(
      webPort: null == webPort
          ? _value.webPort
          : webPort // ignore: cast_nullable_to_non_nullable
              as int,
      outputType: null == outputType
          ? _value.outputType
          : outputType // ignore: cast_nullable_to_non_nullable
              as OutputType,
      weatherServiceIp: null == weatherServiceIp
          ? _value.weatherServiceIp
          : weatherServiceIp // ignore: cast_nullable_to_non_nullable
              as String,
      weatherApiSecret: freezed == weatherApiSecret
          ? _value.weatherApiSecret
          : weatherApiSecret // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      seasonalAdjustment: null == seasonalAdjustment
          ? _value.seasonalAdjustment
          : seasonalAdjustment // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SettingsImpl extends _Settings {
  const _$SettingsImpl(
      {required this.webPort,
      required this.outputType,
      required this.weatherServiceIp,
      this.weatherApiSecret,
      this.location,
      required this.seasonalAdjustment})
      : super._();

  @override
  final int webPort;
  @override
  final OutputType outputType;
  @override
  final String weatherServiceIp;
  @override
  final String? weatherApiSecret;
  @override
  final String? location;
// Format: "latitude,longitude"
  @override
  final int seasonalAdjustment;

  @override
  String toString() {
    return 'Settings(webPort: $webPort, outputType: $outputType, weatherServiceIp: $weatherServiceIp, weatherApiSecret: $weatherApiSecret, location: $location, seasonalAdjustment: $seasonalAdjustment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsImpl &&
            (identical(other.webPort, webPort) || other.webPort == webPort) &&
            (identical(other.outputType, outputType) ||
                other.outputType == outputType) &&
            (identical(other.weatherServiceIp, weatherServiceIp) ||
                other.weatherServiceIp == weatherServiceIp) &&
            (identical(other.weatherApiSecret, weatherApiSecret) ||
                other.weatherApiSecret == weatherApiSecret) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.seasonalAdjustment, seasonalAdjustment) ||
                other.seasonalAdjustment == seasonalAdjustment));
  }

  @override
  int get hashCode => Object.hash(runtimeType, webPort, outputType,
      weatherServiceIp, weatherApiSecret, location, seasonalAdjustment);

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsImplCopyWith<_$SettingsImpl> get copyWith =>
      __$$SettingsImplCopyWithImpl<_$SettingsImpl>(this, _$identity);
}

abstract class _Settings extends Settings {
  const factory _Settings(
      {required final int webPort,
      required final OutputType outputType,
      required final String weatherServiceIp,
      final String? weatherApiSecret,
      final String? location,
      required final int seasonalAdjustment}) = _$SettingsImpl;
  const _Settings._() : super._();

  @override
  int get webPort;
  @override
  OutputType get outputType;
  @override
  String get weatherServiceIp;
  @override
  String? get weatherApiSecret;
  @override
  String? get location; // Format: "latitude,longitude"
  @override
  int get seasonalAdjustment;

  /// Create a copy of Settings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsImplCopyWith<_$SettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
