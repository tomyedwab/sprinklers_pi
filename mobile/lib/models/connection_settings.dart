import 'package:json_annotation/json_annotation.dart';

part 'connection_settings.g.dart';

@JsonSerializable()
class ConnectionSettings {
  final String baseUrl;

  const ConnectionSettings({
    required this.baseUrl,
  });

  factory ConnectionSettings.fromJson(Map<String, dynamic> json) =>
      _$ConnectionSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionSettingsToJson(this);

  /// Default settings with an invalid base URL to force explicit configuration
  static const ConnectionSettings defaultSettings = ConnectionSettings(
    baseUrl: '',
  );
} 