import 'package:freezed_annotation/freezed_annotation.dart';
import '../api/models/weather_check.dart' as api;

part 'weather.freezed.dart';

@freezed
class Weather with _$Weather {
  const factory Weather({
    required bool hasProvider,
    required bool isKeyValid,
    required bool isDataValid,
    required String providerIp,
    required int adjustmentScale,
    required Temperature temperature,
    required Humidity humidity,
    required Precipitation precipitation,
    required Wind wind,
    required double uvIndex,
  }) = _Weather;

  const Weather._();

  bool get isFullyConfigured => hasProvider && isKeyValid && isDataValid;
  
  double get adjustmentPercentage => adjustmentScale / 100.0;
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

extension ApiWeatherCheckX on api.ApiWeatherCheck {
  Weather toModel() {
    return Weather(
      hasProvider: !noprovider,
      isKeyValid: !keynotfound,
      isDataValid: valid,
      providerIp: resolvedIP,
      adjustmentScale: scale,
      temperature: Temperature(
        fahrenheit: meantempi.toDouble(),
      ),
      humidity: Humidity(
        minimum: minhumidity,
        maximum: maxhumidity,
      ),
      precipitation: Precipitation(
        yesterdayInches: precip / 100.0,
        todayInches: precip_today / 100.0,
      ),
      wind: Wind(
        mph: wind_mph / 10.0,
      ),
      uvIndex: UV / 10.0,
    );
  }
} 