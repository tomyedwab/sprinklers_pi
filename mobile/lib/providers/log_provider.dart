import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/models/log.dart' as api;
import '../models/log.dart';
import 'api_provider.dart';

part 'log_provider.g.dart';

@riverpod
class LogNotifier extends _$LogNotifier {
  Future<Map<int, List<GraphPoint>>> build() async {
    // By default, fetch logs for the last 24 hours
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 1));
    return _fetchLogs(startDate: startDate, endDate: endDate);
  }

  Future<Map<int, List<GraphPoint>>> _fetchLogs({
    required DateTime startDate,
    required DateTime endDate,
    api.LogGrouping grouping = api.LogGrouping.month,
  }) async {
    final apiClient = ref.read(apiClientProvider);
    final response = await apiClient.getLogs(
      startDate: startDate,
      endDate: endDate,
      grouping: grouping,
    );
    return response.toModel() as Map<int, List<GraphPoint>>;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<Map<int, List<GraphPoint>>> fetchDateRange({
    required DateTime startDate,
    required DateTime endDate,
    api.LogGrouping grouping = api.LogGrouping.month,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchLogs(
      startDate: startDate,
      endDate: endDate,
      grouping: grouping,
    ));
    return state.value ?? {};
  }
}

@riverpod
class TableLogNotifier extends _$TableLogNotifier {
  Future<List<ZoneLog>> build() async {
    // By default, fetch logs for the last 24 hours
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 1));
    return _fetchTableLogs(startDate: startDate, endDate: endDate);
  }

  Future<List<ZoneLog>> _fetchTableLogs({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final apiClient = ref.read(apiClientProvider);
    final response = await apiClient.getTableLogs(
      startDate: startDate,
      endDate: endDate,
    );
    return response.toModel() as List<ZoneLog>;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<List<ZoneLog>> fetchDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTableLogs(
      startDate: startDate,
      endDate: endDate,
    ));
    return state.value ?? [];
  }
} 