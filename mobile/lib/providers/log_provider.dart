import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/models/log.dart' as api;
import '../models/log.dart';
import 'api_provider.dart';
import 'dart:async';

part 'log_provider.g.dart';

class LogFetchException implements Exception {
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;

  LogFetchException(this.message, {this.originalError, this.stackTrace});

  @override
  String toString() => 'LogFetchException: $message${originalError != null ? '\nOriginal error: $originalError' : ''}';
}

@riverpod
class LogNotifier extends _$LogNotifier {
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

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
    int retryCount = 0,
  }) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.getLogs(
        startDate: startDate,
        endDate: endDate,
        grouping: grouping,
      );
      return response.toModel() as Map<int, List<GraphPoint>>;
    } catch (e, stackTrace) {
      if (retryCount < maxRetries) {
        // Wait before retrying
        await Future.delayed(retryDelay * (retryCount + 1));
        return _fetchLogs(
          startDate: startDate,
          endDate: endDate,
          grouping: grouping,
          retryCount: retryCount + 1,
        );
      }
      throw LogFetchException(
        'Failed to fetch graph logs after $maxRetries retries',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
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
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  Future<List<ZoneLog>> build() async {
    // By default, fetch logs for the last 24 hours
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 1));
    return _fetchTableLogs(startDate: startDate, endDate: endDate);
  }

  Future<List<ZoneLog>> _fetchTableLogs({
    required DateTime startDate,
    required DateTime endDate,
    int retryCount = 0,
  }) async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.getTableLogs(
        startDate: startDate,
        endDate: endDate,
      );
      return response.toModel() as List<ZoneLog>;
    } catch (e, stackTrace) {
      if (retryCount < maxRetries) {
        // Wait before retrying with exponential backoff
        await Future.delayed(retryDelay * (retryCount + 1));
        return _fetchTableLogs(
          startDate: startDate,
          endDate: endDate,
          retryCount: retryCount + 1,
        );
      }
      throw LogFetchException(
        'Failed to fetch table logs after $maxRetries retries',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
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