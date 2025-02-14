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
      id: json['id'] as int,
      name: json['name'] as String,
      e: json['e'] as String,
      next: json['next'] as String,
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
      table: (json['Table'] as List<dynamic>)
          .map((e) => ApiScheduleListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'Table': table.map((e) => e.toJson()).toList(),
  };
}

// Schedule detail response models
class ApiScheduleTime {
  final String t;  // Time in HH:MM format
  final String e;  // Time slot enabled ("on"/"off")

  ApiScheduleTime({
    required this.t,
    required this.e,
  });

  factory ApiScheduleTime.fromJson(Map<String, dynamic> json) {
    return ApiScheduleTime(
      t: json['t'] as String,
      e: json['e'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    't': t,
    'e': e,
  };
}

class ApiScheduleZone {
  final int duration;  // Run time in minutes (0-255)
  final String e;     // Zone enabled in schedule ("on"/"off")

  ApiScheduleZone({
    required this.duration,
    required this.e,
  });

  factory ApiScheduleZone.fromJson(Map<String, dynamic> json) {
    return ApiScheduleZone(
      duration: json['duration'] as int,
      e: json['e'] as String,
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
  final String type;    // "on" = day-based, "off" = interval-based
  final int interval;   // Days between runs (1-20)
  final int restrict;   // 0=None, 1=Odd days, 2=Even days
  final String d1;      // Sunday enabled ("on"/"off")
  final String d2;      // Monday enabled ("on"/"off")
  final String d3;      // Tuesday enabled ("on"/"off")
  final String d4;      // Wednesday enabled ("on"/"off")
  final String d5;      // Thursday enabled ("on"/"off")
  final String d6;      // Friday enabled ("on"/"off")
  final String d7;      // Saturday enabled ("on"/"off")
  final List<ApiScheduleTime> times;
  final List<ApiScheduleZone> zones;

  ApiScheduleDetail({
    required this.name,
    required this.enabled,
    required this.type,
    required this.interval,
    required this.restrict,
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
      name: json['name'] as String,
      enabled: json['enabled'] as String,
      type: json['type'] as String,
      interval: json['interval'] as int,
      restrict: json['restrict'] as int,
      d1: json['d1'] as String,
      d2: json['d2'] as String,
      d3: json['d3'] as String,
      d4: json['d4'] as String,
      d5: json['d5'] as String,
      d6: json['d6'] as String,
      d7: json['d7'] as String,
      times: (json['times'] as List<dynamic>)
          .map((e) => ApiScheduleTime.fromJson(e as Map<String, dynamic>))
          .toList(),
      zones: (json['zones'] as List<dynamic>)
          .map((e) => ApiScheduleZone.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'enabled': enabled,
    'type': type,
    'interval': interval,
    'restrict': restrict,
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