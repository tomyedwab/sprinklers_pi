import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/api_client.dart';
import '../models/schedule.dart';
import '../api/models/schedule.dart';

part 'schedule_provider.g.dart';

@riverpod
class ScheduleListNotifier extends _$ScheduleListNotifier {
  @override
  Future<List<ScheduleListItem>> build() async {
    final apiClient = ref.watch(apiClientProvider);
    final scheduleList = await apiClient.getSchedules();
    return scheduleList.map((s) => s.toModel()).toList();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<ScheduleDetail> getScheduleDetails(int id) async {
    final apiClient = ref.read(apiClientProvider);
    final apiSchedule = await apiClient.getSchedule(id);
    final model = apiSchedule.toModel();
    final result = model.copyWith(id: id);
    return result;
  }

  Future<void> deleteSchedule(int id) async {
    final apiClient = ref.read(apiClientProvider);
    await apiClient.deleteSchedule(id);
    ref.invalidateSelf();
  }

  Future<void> saveSchedule(ScheduleDetail schedule) async {
    final apiClient = ref.read(apiClientProvider);
    await apiClient.saveSchedule(schedule);
    ref.invalidateSelf();
  }
}

@riverpod
Future<ScheduleDetail> scheduleDetails(
  ScheduleDetailsRef ref,
  int id,
) async {
  return ref.watch(scheduleListNotifierProvider.notifier).getScheduleDetails(id);
} 