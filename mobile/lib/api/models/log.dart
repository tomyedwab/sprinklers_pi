class ApiLogEntry {
  final int date;
  final int duration;
  final int schedule;
  final int seasonal;
  final int wunderground;

  ApiLogEntry({
    required this.date,
    required this.duration,
    required this.schedule,
    required this.seasonal,
    required this.wunderground,
  });

  factory ApiLogEntry.fromJson(Map<String, dynamic> json) {
    return ApiLogEntry(
      date: json['date'] as int,
      duration: json['duration'] as int,
      schedule: json['schedule'] as int,
      seasonal: json['seasonal'] as int,
      wunderground: json['wunderground'] as int,
    );
  }
}

class ApiZoneLog {
  final int zone;
  final List<ApiLogEntry> entries;

  ApiZoneLog({
    required this.zone,
    required this.entries,
  });

  factory ApiZoneLog.fromJson(Map<String, dynamic> json) {
    return ApiZoneLog(
      zone: json['zone'] as int,
      entries: (json['entries'] as List<dynamic>)
          .map((e) => ApiLogEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ApiLogResponse {
  final List<ApiZoneLog>? logs;  // For table view
  final Map<String, List<List<int>>>? graphData;  // For graph view

  ApiLogResponse({
    this.logs,
    this.graphData,
  });

  factory ApiLogResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('logs')) {
      // Table view format
      return ApiLogResponse(
        logs: (json['logs'] as List<dynamic>)
            .map((e) => ApiZoneLog.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } else {
      // Graph view format
      return ApiLogResponse(
        graphData: (json as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            (value as List<dynamic>).map((point) => 
              (point as List<dynamic>).map((e) => e as int).toList()
            ).toList(),
          ),
        ),
      );
    }
  }
}

class ApiGraphPoint {
  final int timestamp;
  final int value;

  ApiGraphPoint({
    required this.timestamp,
    required this.value,
  });

  factory ApiGraphPoint.fromArray(List<int> array) {
    return ApiGraphPoint(
      timestamp: array[0] ~/ 1000, // Convert milliseconds to seconds
      value: array[1],
    );
  }
}

enum LogGrouping {
  none('n'),
  hour('h'),
  dayOfWeek('d'),
  month('m');

  final String value;
  const LogGrouping(this.value);
} 