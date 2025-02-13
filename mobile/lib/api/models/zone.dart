class Zone {
  final int id;
  final String name;
  final bool isEnabled;
  final bool isRunning;
  final bool isPumpAssociated;
  final int wateringTime;
  final String? description;

  Zone({
    required this.id,
    required this.name,
    required this.isEnabled,
    required this.isRunning,
    this.isPumpAssociated = false,
    this.wateringTime = 0,
    this.description,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    // In the response, we don't get an ID, but we can infer it from the position in the array
    return Zone(
      id: 0, // This will be set by the API client based on array position
      name: json['name'] as String,
      isEnabled: json['enabled'] == 'on',
      isRunning: json['state'] == 'on',
      isPumpAssociated: json['pump'] == 'on',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'enabled': isEnabled ? 'on' : 'off',
    'state': isRunning ? 'on' : 'off',
    'pump': isPumpAssociated ? 'on' : 'off',
  };
} 