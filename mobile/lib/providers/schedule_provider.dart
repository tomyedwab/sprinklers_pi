import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/api_client.dart';
import '../models/schedule.dart';
import '../api/models/schedule.dart' as api_model;

part 'schedule_provider.g.dart';

@riverpod
class ScheduleListNotifier extends _$ScheduleListNotifier {
  @override
  Future<List<Schedule>> build() async {
    final apiClient = ref.watch(apiClientProvider);
    final scheduleList = await apiClient.getSchedules();
    return scheduleList.map((item) => ApiScheduleX.fromApiListItem(item)).toList();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<Schedule> getScheduleDetails(int id) async {
    final apiClient = ref.read(apiClientProvider);
    final apiSchedule = await apiClient.getSchedule(id);
    final scheduleList = await future;
    final listItem = scheduleList.firstWhere((s) => s.id == id);
    return ApiScheduleX.fromApiSchedule(id, apiSchedule, nextRun: listItem.nextRun);
  }

  Future<void> deleteSchedule(int id) async {
    final apiClient = ref.read(apiClientProvider);
    await apiClient.deleteSchedule(id);
    ref.invalidateSelf();
  }

  Future<void> saveSchedule(Schedule schedule) async {
    final apiClient = ref.read(apiClientProvider);
    await apiClient.saveSchedule(schedule);
    ref.invalidateSelf();
  }
}

@riverpod
Future<Schedule> scheduleDetails(
  ScheduleDetailsRef ref,
  int id,
) async {
  return ref.watch(scheduleListNotifierProvider.notifier).getScheduleDetails(id);
} 