import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';

@freezed
class Weather with _$Weather {
  const factory Weather({
    required bool noProvider,
    required bool keyNotFound,
    required bool valid,
    String? resolvedIP,
    required int scale,
    required double meanTemperature,
    required int minHumidity,
    required int maxHumidity,
    required double precipitation,
    required double precipitationToday,
    required double windSpeed,
    required int uvIndex,
  }) = _Weather;

  const Weather._();

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      noProvider: json['noprovider']?.toString() == 'true',
      keyNotFound: json['keynotfound']?.toString() == 'true',
      valid: json['valid']?.toString() == 'true',
      resolvedIP: json['resolvedIP'] as String?,
      scale: int.tryParse(json['scale']?.toString() ?? '100') ?? 100,
      meanTemperature: double.tryParse(json['meantempi']?.toString() ?? '0') ?? 0,
      minHumidity: int.tryParse(json['minhumidity']?.toString() ?? '0') ?? 0,
      maxHumidity: int.tryParse(json['maxhumidity']?.toString() ?? '0') ?? 0,
      precipitation: double.tryParse(json['precip']?.toString() ?? '0') ?? 0,
      precipitationToday: double.tryParse(json['precip_today']?.toString() ?? '0') ?? 0,
      windSpeed: double.tryParse(json['wind_mph']?.toString() ?? '0') ?? 0,
      uvIndex: int.tryParse(json['UV']?.toString() ?? '0') ?? 0,
    );
  }

  bool get isFullyConfigured => !noProvider && !keyNotFound && valid;
  double get adjustmentPercentage => scale / 100.0;
}

@freezed
class Temperature with _$Temperature {
  const factory Temperature({
    required double fahrenheit,
  }) = _Temperature;

  const Temperature._();

  double get celsius => (fahrenheit - 32) * 5 / 9;
}

@freezed
class Humidity with _$Humidity {
  const factory Humidity({
    required int minimum,
    required int maximum,
  }) = _Humidity;

  const Humidity._();

  int get average => (minimum + maximum) ~/ 2;
}

@freezed
class Precipitation with _$Precipitation {
  const factory Precipitation({
    required double yesterdayInches,
    required double todayInches,
  }) = _Precipitation;

  const Precipitation._();

  double get yesterdayMillimeters => yesterdayInches * 25.4;
  double get todayMillimeters => todayInches * 25.4;
  double get totalInches => yesterdayInches + todayInches;
  double get totalMillimeters => totalInches * 25.4;
}

@freezed
class Wind with _$Wind {
  const factory Wind({
    required double mph,
  }) = _Wind;

  const Wind._();

  double get metersPerSecond => mph * 0.44704;
} 