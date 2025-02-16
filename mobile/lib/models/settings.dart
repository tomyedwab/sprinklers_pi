import 'package:freezed_annotation/freezed_annotation.dart';
import '../api/models/settings.dart';

part 'settings.freezed.dart';

enum OutputType {
  none,
  directPositive,
  directNegative,
  openSprinkler,
}

@freezed
class Settings with _$Settings {
  const factory Settings({
    required int webPort,
    required OutputType outputType,
    required String weatherServiceIp,
    String? weatherApiSecret,
    String? location,  // Format: "latitude,longitude"
    required int seasonalAdjustment,  // 0-200%
  }) = _Settings;

  const Settings._();

  // Validation methods
  bool get isWebPortValid => webPort >= 0 && webPort <= 32767;
  bool get isSeasonalAdjustmentValid => seasonalAdjustment >= 0 && seasonalAdjustment <= 200;
}

extension ApiSettingsX on ApiSettings {
  Settings toModel() {
    return Settings(
      webPort: int.parse(webport),
      outputType: switch (ot) {
        '0' => OutputType.none,
        '1' => OutputType.directPositive,
        '2' => OutputType.directNegative,
        '3' => OutputType.openSprinkler,
        _ => OutputType.none,
      },
      weatherServiceIp: wuip,
      weatherApiSecret: apisecret,
      location: loc,
      seasonalAdjustment: int.parse(sadj),
    );
  }
}

extension SettingsX on Settings {
  Map<String, String> toApiParams() {
    return {
      'webport': webPort.toString(),
      'ot': switch (outputType) {
        OutputType.none => '0',
        OutputType.directPositive => '1',
        OutputType.directNegative => '2',
        OutputType.openSprinkler => '3',
      },
      'wuip': weatherServiceIp,
      if (weatherApiSecret != null) 'apisecret': weatherApiSecret!,
      if (location != null) 'loc': location!,
      'sadj': seasonalAdjustment.toString(),
    };
  }
} 