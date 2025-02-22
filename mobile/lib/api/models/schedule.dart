// Helper functions for standardized parameter conversion
String _stringOrDefault(dynamic value, String defaultValue) => value as String? ?? defaultValue;
bool _stringToBool(String? value) => value == 'on';
String _boolToString(bool value) => value ? 'on' : 'off';
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

// Schedule list response models
class ApiScheduleListItem {
  final int id;
  final String name;
  final String e;     // "on"/"off"
  final String next;  // Next run time description

  ApiScheduleListItem({
    required this.id,
    required this.name,
    required this.e,
    required this.next,
  });

  factory ApiScheduleListItem.fromJson(Map<String, dynamic> json) {
    return ApiScheduleListItem(
      id: _parseIntSafe(json['id'], 0),
      name: _stringOrDefault(json['name'], ''),
      e: _stringOrDefault(json['e'], 'off'),
      next: _stringOrDefault(json['next'], ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'e': e,
    'next': next,
  };
}

class ApiScheduleList {
  final List<ApiScheduleListItem> table;

  ApiScheduleList({
    required this.table,
  });

  factory ApiScheduleList.fromJson(Map<String, dynamic> json) {
    return ApiScheduleList(
      table: (json['Table'] as List<dynamic>?)
          ?.map((e) => ApiScheduleListItem.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'Table': table.map((e) => e.toJson()).toList(),
  };
}

// Schedule detail response models
class ApiScheduleTime {
  final String t;  // "HH:MM" format
  final String e;  // "on"/"off"

  ApiScheduleTime({
    required this.t,
    required this.e,
  });

  factory ApiScheduleTime.fromJson(Map<String, dynamic> json) {
    return ApiScheduleTime(
      t: _stringOrDefault(json['t'], '00:00'),
      e: _stringOrDefault(json['e'], 'off'),
    );
  }

  Map<String, dynamic> toJson() => {
    't': t,
    'e': e,
  };
}

class ApiScheduleZone {
  final int duration;
  final String e;  // "on"/"off"

  ApiScheduleZone({
    required this.duration,
    required this.e,
  });

  factory ApiScheduleZone.fromJson(Map<String, dynamic> json) {
    return ApiScheduleZone(
      duration: _parseIntSafe(json['duration'], 0),
      e: _stringOrDefault(json['e'], 'off'),
    );
  }

  Map<String, dynamic> toJson() => {
    'duration': duration,
    'e': e,
  };
}

class ApiScheduleDetail {
  final String name;
  final String enabled;  // "on"/"off"
  final String type;    // "on"=Day-based, "off"=Interval
  final String interval;  // String representation of interval (1-20)
  final String restrict;  // "0"=None, "1"=Odd, "2"=Even
  final String wadj;     // "on"/"off"
  final String d1;       // "on"/"off" for Sunday
  final String d2;       // "on"/"off" for Monday
  final String d3;       // "on"/"off" for Tuesday
  final String d4;       // "on"/"off" for Wednesday
  final String d5;       // "on"/"off" for Thursday
  final String d6;       // "on"/"off" for Friday
  final String d7;       // "on"/"off" for Saturday
  final List<ApiScheduleTime> times;
  final List<ApiScheduleZone> zones;

  ApiScheduleDetail({
    required this.name,
    required this.enabled,
    required this.type,
    required this.interval,
    required this.restrict,
    required this.wadj,
    required this.d1,
    required this.d2,
    required this.d3,
    required this.d4,
    required this.d5,
    required this.d6,
    required this.d7,
    required this.times,
    required this.zones,
  });

  factory ApiScheduleDetail.fromJson(Map<String, dynamic> json) {
    return ApiScheduleDetail(
      name: _stringOrDefault(json['name'], ''),
      enabled: _stringOrDefault(json['enabled'], 'off'),
      type: _stringOrDefault(json['type'], 'off'),
      interval: _stringOrDefault(json['interval'], '1'),
      restrict: _stringOrDefault(json['restrict'], '0'),
      wadj: _stringOrDefault(json['wadj'], 'off'),
      d1: _stringOrDefault(json['d1'], 'off'),
      d2: _stringOrDefault(json['d2'], 'off'),
      d3: _stringOrDefault(json['d3'], 'off'),
      d4: _stringOrDefault(json['d4'], 'off'),
      d5: _stringOrDefault(json['d5'], 'off'),
      d6: _stringOrDefault(json['d6'], 'off'),
      d7: _stringOrDefault(json['d7'], 'off'),
      times: (json['times'] as List<dynamic>?)
          ?.map((e) => ApiScheduleTime.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      zones: (json['zones'] as List<dynamic>?)
          ?.map((e) => ApiScheduleZone.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'enabled': enabled,
    'type': type,
    'interval': interval,
    'restrict': restrict,
    'wadj': wadj,
    'd1': d1,
    'd2': d2,
    'd3': d3,
    'd4': d4,
    'd5': d5,
    'd6': d6,
    'd7': d7,
    'times': times.map((e) => e.toJson()).toList(),
    'zones': zones.map((e) => e.toJson()).toList(),
  };
} 