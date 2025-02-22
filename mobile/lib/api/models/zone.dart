class Zone {
  final int id;
  final String name;
  final bool isEnabled;
  final bool state;
  final bool isPumpAssociated;
  final int wateringTime;
  final String? description;

  Zone({
    required this.id,
    required this.name,
    required this.isEnabled,
    required this.state,
    this.isPumpAssociated = false,
    this.wateringTime = 0,
    this.description,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    // In the response, we don't get an ID, but we can infer it from the position in the array
    return Zone(
      id: 0, // This will be set by the API client based on array position
      name: json['name'] as String? ?? '',  // Default to empty string if null
      isEnabled: (json['enabled'] as String?) == 'on',  // Handle null case
      state: (json['state'] as String?) == 'on',  // Handle null case
      isPumpAssociated: (json['pump'] as String?) == 'on',  // Handle null case
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'enabled': isEnabled ? 'on' : 'off',
    'state': state ? 'on' : 'off',
    'pump': isPumpAssociated ? 'on' : 'off',
  };

  Zone copyWith({
    int? id,
    String? name,
    bool? isEnabled,
    bool? state,
    bool? isPumpAssociated,
    int? wateringTime,
    String? description,
  }) {
    return Zone(
      id: id ?? this.id,
      name: name ?? this.name,
      isEnabled: isEnabled ?? this.isEnabled,
      state: state ?? this.state,
      isPumpAssociated: isPumpAssociated ?? this.isPumpAssociated,
      wateringTime: wateringTime ?? this.wateringTime,
      description: description ?? this.description,
    );
  }
} 