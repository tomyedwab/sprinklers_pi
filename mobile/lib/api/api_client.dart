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
      return zonesJson.map((json) => Zone.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to get zones: ${e.toString()}');
    }
  }

  /// Set zone state
  Future<void> setZoneState(String zoneId, bool state) async {
    try {
      await _get(
        ApiConfig.manualControl,
        {
          'zone': zoneId,
          'state': state ? 'on' : 'off',
        },
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to set zone state: ${e.toString()}');
    }
  }
} 