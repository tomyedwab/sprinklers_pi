class ApiQuickScheduleRequest {
  final String sched;
  final Map<String, int> zoneDurations;

  ApiQuickScheduleRequest({
    required this.sched,
    required this.zoneDurations,
  });

  Map<String, String> toParams() {
    final params = <String, String>{
      'sched': sched,
    };

    // For custom schedules (sched="-1"), we need to send ALL zone durations
    if (sched == "-1") {
      // Add durations for all zones (b through z)
      // This ensures we send durations for all possible zones
      for (var zoneChar = 'b'.codeUnitAt(0); zoneChar <= 'z'.codeUnitAt(0); zoneChar++) {
        final zoneId = (zoneChar - 'b'.codeUnitAt(0)).toString();
        // Use provided duration if exists, otherwise send 0 to retain previous value
        final duration = zoneDurations[zoneId] ?? 0;
        params['z${String.fromCharCode(zoneChar)}'] = duration.toString();
      }
    }

    return params;
  }

  /// Creates a custom quick schedule request
  /// 
  /// [zoneDurations] is a map of zone IDs (0-based) to their durations in minutes.
  /// When using a custom schedule (sched="-1"), the request will include ALL zones
  /// (b through z). Any zones not specified in [zoneDurations] will be set to 0,
  /// which tells the API to retain their previous values from memory.
  static ApiQuickScheduleRequest custom(Map<String, int> zoneDurations) {
    return ApiQuickScheduleRequest(
      sched: "-1",
      zoneDurations: zoneDurations,
    );
  }

  /// Creates a quick schedule request to run an existing schedule
  /// 
  /// [scheduleId] is the ID of the schedule to run
  static ApiQuickScheduleRequest fromSchedule(int scheduleId) {
    return ApiQuickScheduleRequest(
      sched: scheduleId.toString(),
      zoneDurations: {}, // No zone durations needed when running an existing schedule
    );
  }
} 