class ApiSystemState {
  final String version;
  final String run;
  final int zones;
  final int schedules;
  final int timenow;
  final int events;
  final String? onzone;
  final int? offtime;

  ApiSystemState({
    required this.version,
    required this.run,
    required this.zones,
    required this.schedules,
    required this.timenow,
    required this.events,
    this.onzone,
    this.offtime,
  });

  factory ApiSystemState.fromJson(Map<String, dynamic> json) {
    return ApiSystemState(
      version: json['version'] as String,
      run: json['run'] as String,
      zones: int.parse(json['zones'] as String),
      schedules: int.parse(json['schedules'] as String),
      timenow: int.parse(json['timenow'] as String),
      events: int.parse(json['events'] as String),
      onzone: json['onzone'] as String?,
      offtime: json['offtime'] != null ? int.parse(json['offtime'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'run': run,
      'zones': zones.toString(),
      'schedules': schedules.toString(),
      'timenow': timenow.toString(),
      'events': events.toString(),
      if (onzone != null) 'onzone': onzone,
      if (offtime != null) 'offtime': offtime?.toString(),
    };
  }
} 