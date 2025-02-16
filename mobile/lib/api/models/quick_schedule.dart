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

    // Add zone durations with proper API format (za, zb, zc, etc.)
    zoneDurations.forEach((zoneId, duration) {
      // Convert zone ID (0-based) to API format (za, zb, zc, etc.)
      final apiZoneId = String.fromCharCode('a'.codeUnitAt(0) + int.parse(zoneId) + 1);
      params['z$apiZoneId'] = duration.toString();
    });

    return params;
  }
} 