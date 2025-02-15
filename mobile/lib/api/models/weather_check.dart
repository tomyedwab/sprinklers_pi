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
      noprovider: json['noprovider'] == 'true',
      keynotfound: json['keynotfound'] == 'true',
      valid: json['valid'] == 'true',
      resolvedIP: json['resolvedIP'] as String,
      scale: int.parse(json['scale'] as String),
      meantempi: int.parse(json['meantempi'] as String),
      minhumidity: int.parse(json['minhumidity'] as String),
      maxhumidity: int.parse(json['maxhumidity'] as String),
      precip: int.parse(json['precip'] as String),
      precip_today: int.parse(json['precip_today'] as String),
      wind_mph: int.parse(json['wind_mph'] as String),
      UV: int.parse(json['UV'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'noprovider': noprovider.toString(),
    'keynotfound': keynotfound.toString(),
    'valid': valid.toString(),
    'resolvedIP': resolvedIP,
    'scale': scale.toString(),
    'meantempi': meantempi.toString(),
    'minhumidity': minhumidity.toString(),
    'maxhumidity': maxhumidity.toString(),
    'precip': precip.toString(),
    'wind_mph': wind_mph.toString(),
    'UV': UV.toString(),
  };
} 