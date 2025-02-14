import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'api_config.dart';
import 'models/zone.dart';
import 'models/system_state.dart';
import 'models/schedule.dart';
import '../models/schedule.dart' as app_model;

part 'api_client.g.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Helper method to build URLs
  Uri _buildUrl(String endpoint, [Map<String, dynamic>? queryParams]) {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    if (queryParams != null) {
      return uri.replace(queryParameters: queryParams.map(
        (key, value) => MapEntry(key, value.toString()),
      ));
    }
    return uri;
  }

  /// Generic GET request handler
  Future<Map<String, dynamic>> _get(String endpoint, [Map<String, dynamic>? queryParams]) async {
    try {
      final response = await _client
          .get(_buildUrl(endpoint, queryParams))
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw ApiException('Request failed', response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  /// Get all zones
  Future<List<Zone>> getZones() async {
    try {
      final response = await _get(ApiConfig.zones);
      final List<dynamic> zonesJson = response['zones'] as List<dynamic>;
      return zonesJson.map((json) => Zone.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to get zones: ${e.toString()}');
    }
  }

  /// Get system state
  Future<ApiSystemState> getSystemState() async {
    try {
      final response = await _get(ApiConfig.state);
      return ApiSystemState.fromJson(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to get system state: ${e.toString()}');
    }
  }

  /// Toggle zone state
  Future<void> toggleZone(int zoneId, bool enable) async {
    try {
      await _get(
        ApiConfig.manualControl,
        {
          'zone': 'z${String.fromCharCode(96 + zoneId)}',  // Convert 1 to 'za', 2 to 'zb', etc.
          'state': enable ? 'on' : 'off',
        },
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to toggle zone: ${e.toString()}');
    }
  }

  /// Update zone settings
  Future<void> updateZone(Zone zone) async {
    try {
      final zoneId = String.fromCharCode(96 + zone.id); // Convert 1 to 'a', 2 to 'b', etc.
      await _get(
        ApiConfig.setZones,
        {
          'z${zoneId}name': zone.name,
          'z${zoneId}e': zone.isEnabled ? 'on' : 'off',
          'z${zoneId}p': zone.isPumpAssociated ? 'on' : 'off',
        },
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to update zone: ${e.toString()}');
    }
  }

  /// Get all schedules
  Future<List<ApiScheduleListItem>> getSchedules() async {
    try {
      final response = await _get(ApiConfig.schedules);
      return ApiScheduleList.fromJson(response).table;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to get schedules: ${e.toString()}');
    }
  }

  /// Get schedule details by ID
  Future<ApiScheduleDetail> getSchedule(int id) async {
    try {
      final response = await _get(ApiConfig.schedule, {'id': id});
      return ApiScheduleDetail.fromJson(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to get schedule: ${e.toString()}');
    }
  }

  /// Delete a schedule
  Future<void> deleteSchedule(int id) async {
    try {
      await _get(ApiConfig.deleteSchedule, {'id': id});
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to delete schedule: ${e.toString()}');
    }
  }

  /// Update or create a schedule
  Future<void> saveSchedule(app_model.Schedule schedule) async {
    try {
      final params = {
        'id': schedule.id,
        'name': schedule.name,
        'enable': schedule.isEnabled ? 'on' : 'off',
        'type': schedule.isDayBased ? 'on' : 'off',
        'interval': schedule.interval,
        'restrict': schedule.restriction.value,
        'd1': schedule.isSundayEnabled ? 'on' : 'off',
        'd2': schedule.isMondayEnabled ? 'on' : 'off',
        'd3': schedule.isTuesdayEnabled ? 'on' : 'off',
        'd4': schedule.isWednesdayEnabled ? 'on' : 'off',
        'd5': schedule.isThursdayEnabled ? 'on' : 'off',
        'd6': schedule.isFridayEnabled ? 'on' : 'off',
        'd7': schedule.isSaturdayEnabled ? 'on' : 'off',
      };

      // Add time slots
      for (var i = 0; i < schedule.times.length; i++) {
        final time = schedule.times[i];
        params['t${i + 1}'] = time.time;
        params['e${i + 1}'] = time.isEnabled ? 'on' : 'off';
      }

      // Add zone durations
      for (var i = 0; i < schedule.zones.length; i++) {
        final zone = schedule.zones[i];
        final zoneId = String.fromCharCode(97 + i); // Convert 0 to 'a', 1 to 'b', etc.
        params['z$zoneId'] = zone.duration.inMinutes;
      }

      await _get(ApiConfig.setSchedule, params);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to save schedule: ${e.toString()}');
    }
  }
}

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  return ApiClient();
} 