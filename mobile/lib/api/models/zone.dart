class Zone {
  final String name;
  final bool enabled;
  final bool state;
  final bool pump;

  Zone({
    required this.name,
    required this.enabled,
    required this.state,
    required this.pump,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      name: json['name'] as String,
      enabled: json['enabled'] == 'on',
      state: json['state'] == 'on',
      pump: json['pump'] == 'on',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'enabled': enabled ? 'on' : 'off',
    'state': state ? 'on' : 'off',
    'pump': pump ? 'on' : 'off',
  };
} 