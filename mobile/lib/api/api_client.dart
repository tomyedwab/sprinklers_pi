import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'api_config.dart';
import 'models/zone.dart';
import 'models/system_state.dart';
import 'models/schedule.dart';
import '../models/schedule.dart' as app_model;
import 'models/weather_check.dart';

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

  /// Converts a zero-based zone ID to its API zone name (0 -> 'b', 1 -> 'c', etc.)
  String _zoneIdToName(int id) => String.fromCharCode(98 + id);

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
        // Handle empty responses (like from setZones)
        if (response.body.isEmpty) {
          return {};
        }
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
      return zonesJson.asMap().entries.map((entry) {
        final json = entry.value as Map<String, dynamic>;
        return Zone.fromJson(json).copyWith(id: entry.key); // Use 0-based index directly
      }).toList();
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
          'zone': 'z${_zoneIdToName(zoneId)}',  // Convert 0 to 'zb', 1 to 'zc', etc.
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
      // First get all current zones
      final zones = await getZones();
      
      // Create parameters for all zones
      final params = <String, String>{};
      for (final z in zones) {
        final zoneId = _zoneIdToName(z.id);
        // Use the updated values for the zone being modified, otherwise use existing values
        if (z.id == zone.id) {
          params['z${zoneId}name'] = zone.name;
          params['z${zoneId}e'] = zone.isEnabled ? 'on' : 'off';
          params['z${zoneId}p'] = zone.isPumpAssociated ? 'on' : 'off';
        } else {
          params['z${zoneId}name'] = z.name;
          params['z${zoneId}e'] = z.isEnabled ? 'on' : 'off';
          params['z${zoneId}p'] = z.isPumpAssociated ? 'on' : 'off';
        }
      }

      await _get(ApiConfig.setZones, params);
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
  Future<void> saveSchedule(app_model.ScheduleDetail schedule) async {
    try {
      final params = schedule.toApiParams();
      await _get(ApiConfig.setSchedule, params.map(
        (key, value) => MapEntry(key, value.toString()),
      ));
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to save schedule: ${e.toString()}');
    }
  }

  Future<ApiWeatherCheck> getWeatherCheck() async {
    try {
      final response = await _get(ApiConfig.weatherCheck);
      return ApiWeatherCheck.fromJson(response);
    } catch (e) {
      throw ApiException('Failed to get weather data: $e');
    }
  }
}

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  return ApiClient();
} 