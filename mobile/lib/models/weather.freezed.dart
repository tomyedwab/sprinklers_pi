// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Weather {
  bool get hasProvider => throw _privateConstructorUsedError;
  bool get isKeyValid => throw _privateConstructorUsedError;
  bool get isDataValid => throw _privateConstructorUsedError;
  String get providerIp => throw _privateConstructorUsedError;
  int get adjustmentScale => throw _privateConstructorUsedError;
  Temperature get temperature => throw _privateConstructorUsedError;
  Humidity get humidity => throw _privateConstructorUsedError;
  Precipitation get precipitation => throw _privateConstructorUsedError;
  Wind get wind => throw _privateConstructorUsedError;
  double get uvIndex => throw _privateConstructorUsedError;

  /// Create a copy of Weather
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeatherCopyWith<Weather> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherCopyWith<$Res> {
  factory $WeatherCopyWith(Weather value, $Res Function(Weather) then) =
      _$WeatherCopyWithImpl<$Res, Weather>;
  @useResult
  $Res call(
      {bool hasProvider,
      bool isKeyValid,
      bool isDataValid,
      String providerIp,
      int adjustmentScale,
      Temperature temperature,
      Humidity humidity,
      Precipitation precipitation,
      Wind wind,
      double uvIndex});

  $TemperatureCopyWith<$Res> get temperature;
  $HumidityCopyWith<$Res> get humidity;
  $PrecipitationCopyWith<$Res> get precipitation;
  $WindCopyWith<$Res> get wind;
}

/// @nodoc
class _$WeatherCopyWithImpl<$Res, $Val extends Weather>
    implements $WeatherCopyWith<$Res> {
  _$WeatherCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Weather
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasProvider = null,
    Object? isKeyValid = null,
    Object? isDataValid = null,
    Object? providerIp = null,
    Object? adjustmentScale = null,
    Object? temperature = null,
    Object? humidity = null,
    Object? precipitation = null,
    Object? wind = null,
    Object? uvIndex = null,
  }) {
    return _then(_value.copyWith(
      hasProvider: null == hasProvider
          ? _value.hasProvider
          : hasProvider // ignore: cast_nullable_to_non_nullable
              as bool,
      isKeyValid: null == isKeyValid
          ? _value.isKeyValid
          : isKeyValid // ignore: cast_nullable_to_non_nullable
              as bool,
      isDataValid: null == isDataValid
          ? _value.isDataValid
          : isDataValid // ignore: cast_nullable_to_non_nullable
              as bool,
      providerIp: null == providerIp
          ? _value.providerIp
          : providerIp // ignore: cast_nullable_to_non_nullable
              as String,
      adjustmentScale: null == adjustmentScale
          ? _value.adjustmentScale
          : adjustmentScale // ignore: cast_nullable_to_non_nullable
              as int,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as Temperature,
      humidity: null == humidity
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as Humidity,
      precipitation: null == precipitation
          ? _value.precipitation
          : precipitation // ignore: cast_nullable_to_non_nullable
              as Precipitation,
      wind: null == wind
          ? _value.wind
          : wind // ignore: cast_nullable_to_non_nullable
              as Wind,
      uvIndex: null == uvIndex
          ? _value.uvIndex
          : uvIndex // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of Weather
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TemperatureCopyWith<$Res> get temperature {
    return $TemperatureCopyWith<$Res>(_value.temperature, (value) {
      return _then(_value.copyWith(temperature: value) as $Val);
    });
  }

  /// Create a copy of Weather
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HumidityCopyWith<$Res> get humidity {
    return $HumidityCopyWith<$Res>(_value.humidity, (value) {
      return _then(_value.copyWith(humidity: value) as $Val);
    });
  }

  /// Create a copy of Weather
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PrecipitationCopyWith<$Res> get precipitation {
    return $PrecipitationCopyWith<$Res>(_value.precipitation, (value) {
      return _then(_value.copyWith(precipitation: value) as $Val);
    });
  }

  /// Create a copy of Weather
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WindCopyWith<$Res> get wind {
    return $WindCopyWith<$Res>(_value.wind, (value) {
      return _then(_value.copyWith(wind: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WeatherImplCopyWith<$Res> implements $WeatherCopyWith<$Res> {
  factory _$$WeatherImplCopyWith(
          _$WeatherImpl value, $Res Function(_$WeatherImpl) then) =
      __$$WeatherImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool hasProvider,
      bool isKeyValid,
      bool isDataValid,
      String providerIp,
      int adjustmentScale,
      Temperature temperature,
      Humidity humidity,
      Precipitation precipitation,
      Wind wind,
      double uvIndex});

  @override
  $TemperatureCopyWith<$Res> get temperature;
  @override
  $HumidityCopyWith<$Res> get humidity;
  @override
  $PrecipitationCopyWith<$Res> get precipitation;
  @override
  $WindCopyWith<$Res> get wind;
}

/// @nodoc
class __$$WeatherImplCopyWithImpl<$Res>
    extends _$WeatherCopyWithImpl<$Res, _$WeatherImpl>
    implements _$$WeatherImplCopyWith<$Res> {
  __$$WeatherImplCopyWithImpl(
      _$WeatherImpl _value, $Res Function(_$WeatherImpl) _then)
      : super(_value, _then);

  /// Create a copy of Weather
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasProvider = null,
    Object? isKeyValid = null,
    Object? isDataValid = null,
    Object? providerIp = null,
    Object? adjustmentScale = null,
    Object? temperature = null,
    Object? humidity = null,
    Object? precipitation = null,
    Object? wind = null,
    Object? uvIndex = null,
  }) {
    return _then(_$WeatherImpl(
      hasProvider: null == hasProvider
          ? _value.hasProvider
          : hasProvider // ignore: cast_nullable_to_non_nullable
              as bool,
      isKeyValid: null == isKeyValid
          ? _value.isKeyValid
          : isKeyValid // ignore: cast_nullable_to_non_nullable
              as bool,
      isDataValid: null == isDataValid
          ? _value.isDataValid
          : isDataValid // ignore: cast_nullable_to_non_nullable
              as bool,
      providerIp: null == providerIp
          ? _value.providerIp
          : providerIp // ignore: cast_nullable_to_non_nullable
              as String,
      adjustmentScale: null == adjustmentScale
          ? _value.adjustmentScale
          : adjustmentScale // ignore: cast_nullable_to_non_nullable
              as int,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as Temperature,
      humidity: null == humidity
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as Humidity,
      precipitation: null == precipitation
          ? _value.precipitation
          : precipitation // ignore: cast_nullable_to_non_nullable
              as Precipitation,
      wind: null == wind
          ? _value.wind
          : wind // ignore: cast_nullable_to_non_nullable
              as Wind,
      uvIndex: null == uvIndex
          ? _value.uvIndex
          : uvIndex // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$WeatherImpl extends _Weather {
  const _$WeatherImpl(
      {required this.hasProvider,
      required this.isKeyValid,
      required this.isDataValid,
      required this.providerIp,
      required this.adjustmentScale,
      required this.temperature,
      required this.humidity,
      required this.precipitation,
      required this.wind,
      required this.uvIndex})
      : super._();

  @override
  final bool hasProvider;
  @override
  final bool isKeyValid;
  @override
  final bool isDataValid;
  @override
  final String providerIp;
  @override
  final int adjustmentScale;
  @override
  final Temperature temperature;
  @override
  final Humidity humidity;
  @override
  final Precipitation precipitation;
  @override
  final Wind wind;
  @override
  final double uvIndex;

  @override
  String toString() {
    return 'Weather(hasProvider: $hasProvider, isKeyValid: $isKeyValid, isDataValid: $isDataValid, providerIp: $providerIp, adjustmentScale: $adjustmentScale, temperature: $temperature, humidity: $humidity, precipitation: $precipitation, wind: $wind, uvIndex: $uvIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherImpl &&
            (identical(other.hasProvider, hasProvider) ||
                other.hasProvider == hasProvider) &&
            (identical(other.isKeyValid, isKeyValid) ||
                other.isKeyValid == isKeyValid) &&
            (identical(other.isDataValid, isDataValid) ||
                other.isDataValid == isDataValid) &&
            (identical(other.providerIp, providerIp) ||
                other.providerIp == providerIp) &&
            (identical(other.adjustmentScale, adjustmentScale) ||
                other.adjustmentScale == adjustmentScale) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.precipitation, precipitation) ||
                other.precipitation == precipitation) &&
            (identical(other.wind, wind) || other.wind == wind) &&
            (identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      hasProvider,
      isKeyValid,
      isDataValid,
      providerIp,
      adjustmentScale,
      temperature,
      humidity,
      precipitation,
      wind,
      uvIndex);

  /// Create a copy of Weather
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherImplCopyWith<_$WeatherImpl> get copyWith =>
      __$$WeatherImplCopyWithImpl<_$WeatherImpl>(this, _$identity);
}

abstract class _Weather extends Weather {
  const factory _Weather(
      {required final bool hasProvider,
      required final bool isKeyValid,
      required final bool isDataValid,
      required final String providerIp,
      required final int adjustmentScale,
      required final Temperature temperature,
      required final Humidity humidity,
      required final Precipitation precipitation,
      required final Wind wind,
      required final double uvIndex}) = _$WeatherImpl;
  const _Weather._() : super._();

  @override
  bool get hasProvider;
  @override
  bool get isKeyValid;
  @override
  bool get isDataValid;
  @override
  String get providerIp;
  @override
  int get adjustmentScale;
  @override
  Temperature get temperature;
  @override
  Humidity get humidity;
  @override
  Precipitation get precipitation;
  @override
  Wind get wind;
  @override
  double get uvIndex;

  /// Create a copy of Weather
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeatherImplCopyWith<_$WeatherImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Temperature {
  double get fahrenheit => throw _privateConstructorUsedError;

  /// Create a copy of Temperature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TemperatureCopyWith<Temperature> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemperatureCopyWith<$Res> {
  factory $TemperatureCopyWith(
          Temperature value, $Res Function(Temperature) then) =
      _$TemperatureCopyWithImpl<$Res, Temperature>;
  @useResult
  $Res call({double fahrenheit});
}

/// @nodoc
class _$TemperatureCopyWithImpl<$Res, $Val extends Temperature>
    implements $TemperatureCopyWith<$Res> {
  _$TemperatureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Temperature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fahrenheit = null,
  }) {
    return _then(_value.copyWith(
      fahrenheit: null == fahrenheit
          ? _value.fahrenheit
          : fahrenheit // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemperatureImplCopyWith<$Res>
    implements $TemperatureCopyWith<$Res> {
  factory _$$TemperatureImplCopyWith(
          _$TemperatureImpl value, $Res Function(_$TemperatureImpl) then) =
      __$$TemperatureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double fahrenheit});
}

/// @nodoc
class __$$TemperatureImplCopyWithImpl<$Res>
    extends _$TemperatureCopyWithImpl<$Res, _$TemperatureImpl>
    implements _$$TemperatureImplCopyWith<$Res> {
  __$$TemperatureImplCopyWithImpl(
      _$TemperatureImpl _value, $Res Function(_$TemperatureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Temperature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fahrenheit = null,
  }) {
    return _then(_$TemperatureImpl(
      fahrenheit: null == fahrenheit
          ? _value.fahrenheit
          : fahrenheit // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$TemperatureImpl extends _Temperature {
  const _$TemperatureImpl({required this.fahrenheit}) : super._();

  @override
  final double fahrenheit;

  @override
  String toString() {
    return 'Temperature(fahrenheit: $fahrenheit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemperatureImpl &&
            (identical(other.fahrenheit, fahrenheit) ||
                other.fahrenheit == fahrenheit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fahrenheit);

  /// Create a copy of Temperature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TemperatureImplCopyWith<_$TemperatureImpl> get copyWith =>
      __$$TemperatureImplCopyWithImpl<_$TemperatureImpl>(this, _$identity);
}

abstract class _Temperature extends Temperature {
  const factory _Temperature({required final double fahrenheit}) =
      _$TemperatureImpl;
  const _Temperature._() : super._();

  @override
  double get fahrenheit;

  /// Create a copy of Temperature
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TemperatureImplCopyWith<_$TemperatureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Humidity {
  int get minimum => throw _privateConstructorUsedError;
  int get maximum => throw _privateConstructorUsedError;

  /// Create a copy of Humidity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HumidityCopyWith<Humidity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HumidityCopyWith<$Res> {
  factory $HumidityCopyWith(Humidity value, $Res Function(Humidity) then) =
      _$HumidityCopyWithImpl<$Res, Humidity>;
  @useResult
  $Res call({int minimum, int maximum});
}

/// @nodoc
class _$HumidityCopyWithImpl<$Res, $Val extends Humidity>
    implements $HumidityCopyWith<$Res> {
  _$HumidityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Humidity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minimum = null,
    Object? maximum = null,
  }) {
    return _then(_value.copyWith(
      minimum: null == minimum
          ? _value.minimum
          : minimum // ignore: cast_nullable_to_non_nullable
              as int,
      maximum: null == maximum
          ? _value.maximum
          : maximum // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HumidityImplCopyWith<$Res>
    implements $HumidityCopyWith<$Res> {
  factory _$$HumidityImplCopyWith(
          _$HumidityImpl value, $Res Function(_$HumidityImpl) then) =
      __$$HumidityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int minimum, int maximum});
}

/// @nodoc
class __$$HumidityImplCopyWithImpl<$Res>
    extends _$HumidityCopyWithImpl<$Res, _$HumidityImpl>
    implements _$$HumidityImplCopyWith<$Res> {
  __$$HumidityImplCopyWithImpl(
      _$HumidityImpl _value, $Res Function(_$HumidityImpl) _then)
      : super(_value, _then);

  /// Create a copy of Humidity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minimum = null,
    Object? maximum = null,
  }) {
    return _then(_$HumidityImpl(
      minimum: null == minimum
          ? _value.minimum
          : minimum // ignore: cast_nullable_to_non_nullable
              as int,
      maximum: null == maximum
          ? _value.maximum
          : maximum // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$HumidityImpl extends _Humidity {
  const _$HumidityImpl({required this.minimum, required this.maximum})
      : super._();

  @override
  final int minimum;
  @override
  final int maximum;

  @override
  String toString() {
    return 'Humidity(minimum: $minimum, maximum: $maximum)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HumidityImpl &&
            (identical(other.minimum, minimum) || other.minimum == minimum) &&
            (identical(other.maximum, maximum) || other.maximum == maximum));
  }

  @override
  int get hashCode => Object.hash(runtimeType, minimum, maximum);

  /// Create a copy of Humidity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HumidityImplCopyWith<_$HumidityImpl> get copyWith =>
      __$$HumidityImplCopyWithImpl<_$HumidityImpl>(this, _$identity);
}

abstract class _Humidity extends Humidity {
  const factory _Humidity(
      {required final int minimum,
      required final int maximum}) = _$HumidityImpl;
  const _Humidity._() : super._();

  @override
  int get minimum;
  @override
  int get maximum;

  /// Create a copy of Humidity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HumidityImplCopyWith<_$HumidityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Precipitation {
  double get yesterdayInches => throw _privateConstructorUsedError;
  double get todayInches => throw _privateConstructorUsedError;

  /// Create a copy of Precipitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrecipitationCopyWith<Precipitation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrecipitationCopyWith<$Res> {
  factory $PrecipitationCopyWith(
          Precipitation value, $Res Function(Precipitation) then) =
      _$PrecipitationCopyWithImpl<$Res, Precipitation>;
  @useResult
  $Res call({double yesterdayInches, double todayInches});
}

/// @nodoc
class _$PrecipitationCopyWithImpl<$Res, $Val extends Precipitation>
    implements $PrecipitationCopyWith<$Res> {
  _$PrecipitationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Precipitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? yesterdayInches = null,
    Object? todayInches = null,
  }) {
    return _then(_value.copyWith(
      yesterdayInches: null == yesterdayInches
          ? _value.yesterdayInches
          : yesterdayInches // ignore: cast_nullable_to_non_nullable
              as double,
      todayInches: null == todayInches
          ? _value.todayInches
          : todayInches // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrecipitationImplCopyWith<$Res>
    implements $PrecipitationCopyWith<$Res> {
  factory _$$PrecipitationImplCopyWith(
          _$PrecipitationImpl value, $Res Function(_$PrecipitationImpl) then) =
      __$$PrecipitationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double yesterdayInches, double todayInches});
}

/// @nodoc
class __$$PrecipitationImplCopyWithImpl<$Res>
    extends _$PrecipitationCopyWithImpl<$Res, _$PrecipitationImpl>
    implements _$$PrecipitationImplCopyWith<$Res> {
  __$$PrecipitationImplCopyWithImpl(
      _$PrecipitationImpl _value, $Res Function(_$PrecipitationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Precipitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? yesterdayInches = null,
    Object? todayInches = null,
  }) {
    return _then(_$PrecipitationImpl(
      yesterdayInches: null == yesterdayInches
          ? _value.yesterdayInches
          : yesterdayInches // ignore: cast_nullable_to_non_nullable
              as double,
      todayInches: null == todayInches
          ? _value.todayInches
          : todayInches // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$PrecipitationImpl extends _Precipitation {
  const _$PrecipitationImpl(
      {required this.yesterdayInches, required this.todayInches})
      : super._();

  @override
  final double yesterdayInches;
  @override
  final double todayInches;

  @override
  String toString() {
    return 'Precipitation(yesterdayInches: $yesterdayInches, todayInches: $todayInches)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrecipitationImpl &&
            (identical(other.yesterdayInches, yesterdayInches) ||
                other.yesterdayInches == yesterdayInches) &&
            (identical(other.todayInches, todayInches) ||
                other.todayInches == todayInches));
  }

  @override
  int get hashCode => Object.hash(runtimeType, yesterdayInches, todayInches);

  /// Create a copy of Precipitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrecipitationImplCopyWith<_$PrecipitationImpl> get copyWith =>
      __$$PrecipitationImplCopyWithImpl<_$PrecipitationImpl>(this, _$identity);
}

abstract class _Precipitation extends Precipitation {
  const factory _Precipitation(
      {required final double yesterdayInches,
      required final double todayInches}) = _$PrecipitationImpl;
  const _Precipitation._() : super._();

  @override
  double get yesterdayInches;
  @override
  double get todayInches;

  /// Create a copy of Precipitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrecipitationImplCopyWith<_$PrecipitationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Wind {
  double get mph => throw _privateConstructorUsedError;

  /// Create a copy of Wind
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WindCopyWith<Wind> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WindCopyWith<$Res> {
  factory $WindCopyWith(Wind value, $Res Function(Wind) then) =
      _$WindCopyWithImpl<$Res, Wind>;
  @useResult
  $Res call({double mph});
}

/// @nodoc
class _$WindCopyWithImpl<$Res, $Val extends Wind>
    implements $WindCopyWith<$Res> {
  _$WindCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Wind
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mph = null,
  }) {
    return _then(_value.copyWith(
      mph: null == mph
          ? _value.mph
          : mph // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WindImplCopyWith<$Res> implements $WindCopyWith<$Res> {
  factory _$$WindImplCopyWith(
          _$WindImpl value, $Res Function(_$WindImpl) then) =
      __$$WindImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double mph});
}

/// @nodoc
class __$$WindImplCopyWithImpl<$Res>
    extends _$WindCopyWithImpl<$Res, _$WindImpl>
    implements _$$WindImplCopyWith<$Res> {
  __$$WindImplCopyWithImpl(_$WindImpl _value, $Res Function(_$WindImpl) _then)
      : super(_value, _then);

  /// Create a copy of Wind
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mph = null,
  }) {
    return _then(_$WindImpl(
      mph: null == mph
          ? _value.mph
          : mph // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$WindImpl extends _Wind {
  const _$WindImpl({required this.mph}) : super._();

  @override
  final double mph;

  @override
  String toString() {
    return 'Wind(mph: $mph)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WindImpl &&
            (identical(other.mph, mph) || other.mph == mph));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mph);

  /// Create a copy of Wind
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WindImplCopyWith<_$WindImpl> get copyWith =>
      __$$WindImplCopyWithImpl<_$WindImpl>(this, _$identity);
}

abstract class _Wind extends Wind {
  const factory _Wind({required final double mph}) = _$WindImpl;
  const _Wind._() : super._();

  @override
  double get mph;

  /// Create a copy of Wind
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WindImplCopyWith<_$WindImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
