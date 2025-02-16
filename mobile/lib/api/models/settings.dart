class ApiSettings {
  final String webport;  // Port number as string
  final String ot;      // Output type as string
  final String wuip;    // Weather Underground IP
  final String? apisecret;  // API secret (nullable)
  final String? loc;    // Location coordinates (nullable)
  final String sadj;    // Seasonal adjustment as string

  ApiSettings({
    required this.webport,
    required this.ot,
    required this.wuip,
    this.apisecret,
    this.loc,
    required this.sadj,
  });

  factory ApiSettings.fromJson(Map<String, dynamic> json) {
    return ApiSettings(
      webport: json['webport'] as String,
      ot: json['ot'] as String,
      wuip: json['wuip'] as String,
      apisecret: json['apisecret'] as String?,
      loc: json['loc'] as String?,
      sadj: json['sadj'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'webport': webport,
    'ot': ot,
    'wuip': wuip,
    if (apisecret != null) 'apisecret': apisecret!,
    if (loc != null) 'loc': loc!,
    'sadj': sadj,
  };
} 