import 'package:freezed_annotation/freezed_annotation.dart';
import '../api/models/log.dart' as api;

part 'log.freezed.dart';

@freezed
class LogEntry with _$LogEntry {
  const factory LogEntry({
    required DateTime date,
    required Duration duration,
    required int scheduleId,  // -1=Manual, 100=Quick
    required int seasonalAdjustment,
    required int weatherAdjustment,
  }) = _LogEntry;

  const LogEntry._();

  bool get isManual => scheduleId == -1;
  bool get isQuickSchedule => scheduleId == 100;
}

@freezed
class ZoneLog with _$ZoneLog {
  const factory ZoneLog({
    required int zoneId,
    required List<LogEntry> entries,
  }) = _ZoneLog;

  const ZoneLog._();

  Duration get totalDuration => entries.fold(
    Duration.zero,
    (total, entry) => total + entry.duration,
  );

  int get totalRuns => entries.length;
}

@freezed
class GraphPoint with _$GraphPoint {
  const factory GraphPoint({
    required DateTime timestamp,
    required Duration value,
  }) = _GraphPoint;
}

extension ApiLogEntryX on api.ApiLogEntry {
  LogEntry toModel() => LogEntry(
    date: DateTime.fromMillisecondsSinceEpoch(date * 1000),
    duration: Duration(seconds: duration),
    scheduleId: schedule,
    seasonalAdjustment: seasonal,
    weatherAdjustment: wunderground,
  );
}

extension ApiZoneLogX on api.ApiZoneLog {
  ZoneLog toModel() => ZoneLog(
    zoneId: zone,
    entries: entries.map((e) => e.toModel()).toList(),
  );
}

extension ApiLogResponseX on api.ApiLogResponse {
  Object toModel() {
    if (logs != null) {
      return logs!.map((e) => e.toModel()).toList();
    } else if (graphData != null) {
      return graphData!.map(
        (key, value) => MapEntry(
          int.parse(key), // Parse zone ID directly
          value.map((point) => GraphPoint(
            timestamp: DateTime.fromMillisecondsSinceEpoch(point[0]), // Use milliseconds directly
            value: Duration(seconds: point[1]),
          )).toList(),
        ),
      );
    } else {
      throw Exception('Invalid log response: no data available');
    }
  }
} 