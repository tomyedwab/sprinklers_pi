import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/models/quick_schedule.dart';
import 'api_provider.dart';

final quickScheduleProvider = Provider((ref) => QuickScheduleService(ref));

class QuickScheduleService {
  final Ref _ref;

  QuickScheduleService(this._ref);

  /// Execute a schedule immediately
  Future<void> executeSchedule(String scheduleId) async {
    final request = ApiQuickScheduleRequest(
      sched: scheduleId,
      zoneDurations: {},
    );
    
    final apiClient = _ref.read(apiClientProvider);
    await apiClient.executeQuickSchedule(request);
  }

  /// Execute a custom quick schedule with specific zone durations
  Future<void> executeCustomSchedule(Map<String, int> zoneDurations) async {
    final request = ApiQuickScheduleRequest(
      sched: "-1", // -1 indicates custom schedule
      zoneDurations: zoneDurations,
    );
    
    final apiClient = _ref.read(apiClientProvider);
    await apiClient.executeQuickSchedule(request);
  }
} 