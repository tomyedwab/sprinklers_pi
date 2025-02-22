// Helper functions for standardized parameter conversion
String _stringOrDefault(dynamic value, String defaultValue) => value as String? ?? defaultValue;
bool _stringToBool(String? value) => value == 'true';
String _boolToString(bool value) => value.toString();
int _parseIntSafe(dynamic value, int defaultValue) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is double) return value.toInt();
  try {
    return int.parse(value.toString());
  } catch (_) {
    return defaultValue;
  }
}

class ApiWeatherCheck {
  final bool noprovider;
  final bool keynotfound;
  final bool valid;
  final String resolvedIP;
  final int scale;
  final int meantempi;
  final int minhumidity;
  final int maxhumidity;
  final int precip;
  final int precip_today;
  final int wind_mph;
  final int UV;

  ApiWeatherCheck({
    required this.noprovider,
    required this.keynotfound,
    required this.valid,
    required this.resolvedIP,
    required this.scale,
    required this.meantempi,
    required this.minhumidity,
    required this.maxhumidity,
    required this.precip,
    required this.precip_today,
    required this.wind_mph,
    required this.UV,
  });

  factory ApiWeatherCheck.fromJson(Map<String, dynamic> json) {
    return ApiWeatherCheck(
      noprovider: _stringToBool(json['noprovider'] as String?),
      keynotfound: _stringToBool(json['keynotfound'] as String?),
      valid: _stringToBool(json['valid'] as String?),
      resolvedIP: _stringOrDefault(json['resolvedIP'], ''),
      scale: _parseIntSafe(json['scale'], 100),  // Default to 100% if null
      meantempi: _parseIntSafe(json['meantempi'], 70),  // Default to 70°F if null
      minhumidity: _parseIntSafe(json['minhumidity'], 30),  // Default to 30% if null
      maxhumidity: _parseIntSafe(json['maxhumidity'], 30),  // Default to 30% if null
      precip: _parseIntSafe(json['precip'], 0),  // Default to 0 if null
      precip_today: _parseIntSafe(json['precip_today'], 0),  // Default to 0 if null
      wind_mph: _parseIntSafe(json['wind_mph'], 0),  // Default to 0 if null
      UV: _parseIntSafe(json['UV'], 0),  // Default to 0 if null
    );
  }

  Map<String, dynamic> toJson() => {
    'noprovider': _boolToString(noprovider),
    'keynotfound': _boolToString(keynotfound),
    'valid': _boolToString(valid),
    'resolvedIP': resolvedIP,
    'scale': scale.toString(),
    'meantempi': meantempi.toString(),
    'minhumidity': minhumidity.toString(),
    'maxhumidity': maxhumidity.toString(),
    'precip': precip.toString(),
    'precip_today': precip_today.toString(),
    'wind_mph': wind_mph.toString(),
    'UV': UV.toString(),
  };
} 