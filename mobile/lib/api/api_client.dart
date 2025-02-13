import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'models/zone.dart';

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
      return zonesJson.asMap().entries.map((entry) {
        final zone = Zone.fromJson(entry.value as Map<String, dynamic>);
        // Set the ID based on array position (1-based index)
        return Zone(
          id: entry.key + 1,
          name: zone.name,
          isEnabled: zone.isEnabled,
          isRunning: zone.isRunning,
          isPumpAssociated: zone.isPumpAssociated,
          wateringTime: zone.wateringTime,
          description: zone.description,
        );
      }).toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to get zones: ${e.toString()}');
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
} 