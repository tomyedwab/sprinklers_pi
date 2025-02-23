import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webview_cookie_jar/webview_cookie_jar.dart';
import 'api_config.dart';
import 'models/zone.dart';
import 'models/system_state.dart';
import 'models/schedule.dart';
import 'models/log.dart';
import 'models/settings.dart';
import '../models/schedule.dart' as app_model;
import '../models/settings.dart' as app_model;
import 'models/weather_check.dart';
import 'models/quick_schedule.dart';

part 'api_client.g.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? redirectLocation;

  ApiException(
    this.message, [
    this.statusCode,
    this.redirectLocation,
  ]);

  bool get isRedirect => statusCode == 302 && redirectLocation != null;

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class ApiClient {
  final http.Client _client;

  // Default retry configuration
  static const int _maxRetries = 6;
  static const Duration _initialRetryDelay = Duration(seconds: 10);
  static const double _backoffFactor = 1.5;

  // Set of endpoints that are safe to retry (idempotent operations)
  static final Set<String> _retryableEndpoints = {
    ApiConfig.state,
    ApiConfig.zones,
    ApiConfig.schedules,
    ApiConfig.schedule,
    ApiConfig.settings,
    ApiConfig.weatherCheck,
    ApiConfig.logs,
    ApiConfig.tableLogs,
  };

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Converts a zero-based zone ID to its API zone name (0 -> 'b', 1 -> 'c', etc.)
  String _zoneIdToName(int id) => String.fromCharCode(98 + id);

  /// Helper method to safely convert parameter values to strings
  String _paramToString(dynamic value) {
    if (value == null) return '';
    if (value is bool) return value ? 'on' : 'off';
    if (value is int || value is double) return value.toString();
    if (value is DateTime) return (value.millisecondsSinceEpoch / 1000).round().toString();
    return value.toString();
  }

  /// Helper method to build URLs with standardized parameter conversion
  Uri _buildUrl(String endpoint, [Map<String, dynamic>? queryParams]) {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    if (queryParams != null) {
      return uri.replace(queryParameters: queryParams.map(
        (key, value) => MapEntry(key, _paramToString(value)),
      ));
    }
    return uri;
  }

  /// Determines if an endpoint supports retries based on its idempotency
  bool _isRetryableEndpoint(String endpoint) {
    return _retryableEndpoints.any((e) => endpoint.startsWith(e));
  }

  /// Calculates the delay for the next retry attempt using exponential backoff
  Duration _getRetryDelay(int attempt) {
    return Duration(
      milliseconds: (_initialRetryDelay.inMilliseconds * 
        pow(_backoffFactor, attempt - 1)).round(),
    );
  }

  static bool get needsWebCookies {
    if (kIsWeb) {
      return false;
    }
    // On android in production, we need to use login cookies we get from the
    // webview
    return true;
  }

  /// Generic GET request handler with comprehensive timeout protection and retry logic
  Future<Map<String, dynamic>> _get(String endpoint, [Map<String, dynamic>? queryParams]) async {
    int retryCount = 0;
    late final http.StreamedResponse streamedResponse;
    
    while (true) {
      try {
        final request = http.Request('GET', _buildUrl(endpoint, queryParams))
          ..followRedirects = false
          ..maxRedirects = 0;

        if (needsWebCookies) {
          final cookies = await WebViewCookieJar.cookieJar.loadForRequest(request.url);
          request.headers['Cookie'] = cookies.map((c) => '${c.name}=${c.value}').join('; ');
        }
        
        // Create a timeout for the entire operation including stream conversion
        final timeoutCompleter = Completer<Map<String, dynamic>>();
        final timeoutTimer = Timer(ApiConfig.timeout, () {
          if (!timeoutCompleter.isCompleted) {
            timeoutCompleter.completeError(
              TimeoutException('Request timed out', ApiConfig.timeout),
            );
          }
        });

        // Start the request with timeout
        streamedResponse = await _client.send(request);

        // Convert the stream to a response with timeout protection
        final response = await http.Response.fromStream(streamedResponse)
            .timeout(ApiConfig.timeout, onTimeout: () {
          throw TimeoutException('Response stream conversion timed out', ApiConfig.timeout);
        });

        // Cancel the timeout timer since we completed successfully
        timeoutTimer.cancel();

        if (response.statusCode == 200) {
          // Handle empty responses (like from setZones)
          if (response.body.isEmpty) {
            return {};
          }
          return json.decode(response.body) as Map<String, dynamic>;
        } else if (response.statusCode == 302) {
          // Handle redirect responses - not retryable
          final location = response.headers['location'];
          throw ApiException(
            'Authentication required',
            response.statusCode,
            location,
          );
        } else {
          throw ApiException('Request failed', response.statusCode);
        }
      } catch (e) {
        // Clean up the response stream if it exists
        try {
          await streamedResponse.stream.drain<void>();
        } catch (_) {
          // Ignore errors during cleanup
        }

        // Don't retry authentication failures or non-retryable endpoints
        if (e is ApiException && e.isRedirect || !_isRetryableEndpoint(endpoint)) {
          rethrow;
        }

        // Check if we should retry
        if (retryCount < _maxRetries && 
            (e is TimeoutException || 
             e is http.ClientException ||
             e is ApiException && e.statusCode != null && e.statusCode! >= 500)) {
          retryCount++;
          final delay = _getRetryDelay(retryCount);
          
          // Log retry attempt (could be replaced with proper logging)
          print('Retrying request to $endpoint (attempt $retryCount) after ${delay.inMilliseconds}ms');
          
          // Wait before retrying
          await Future.delayed(delay);
          continue;
        }

        // If we get here, we've exhausted retries or hit a non-retryable error
        if (e is ApiException) {
          rethrow;
        } else if (e is FormatException) {
          throw ApiException('Invalid response format: ${e.message}');
        } else if (e is TimeoutException) {
          throw ApiException(
            'Request timed out after ${ApiConfig.timeout.inSeconds} seconds and '
            '$retryCount retry attempts'
          );
        } else {
          throw ApiException('Network error: ${e.toString()}');
        }
      }
    }
  }

  /// Retrieves all configured zones from the system.
  /// 
  /// Returns a list of [Zone] objects with their current state and configuration.
  /// The zone IDs are assigned based on their position in the response array (0-based).
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - The response format is invalid
  /// - Authentication is required
  Future<List<Zone>> getZones() async {
    final response = await _get(ApiConfig.zones);
    final List<dynamic> zonesJson = response['zones'] as List<dynamic>;
    return zonesJson.asMap().entries.map((entry) {
      final json = entry.value as Map<String, dynamic>;
      return Zone.fromJson(json).copyWith(id: entry.key);
    }).toList();
  }

  /// Retrieves the current system state including active zones and schedules.
  /// 
  /// Returns an [ApiSystemState] object containing:
  /// - System version
  /// - Run state ('on'/'off')
  /// - Number of configured zones and schedules
  /// - Currently active zone (if any)
  /// - Remaining time for active zone
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - The response format is invalid
  /// - Authentication is required
  Future<ApiSystemState> getSystemState() async {
    final response = await _get(ApiConfig.state);
    return ApiSystemState.fromJson(response);
  }

  /// Toggles a specific zone on or off.
  /// 
  /// Parameters:
  /// - [zoneId]: Zero-based zone ID (0 for first zone)
  /// - [enable]: true to turn on, false to turn off
  /// 
  /// The zone ID is converted to the API's letter-based system:
  /// - 0 -> 'zb'
  /// - 1 -> 'zc'
  /// etc.
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - Authentication is required
  /// - The zone ID is invalid
  Future<void> toggleZone(int zoneId, bool enable) async {
    await _get(
      ApiConfig.manualControl,
      {
        'zone': 'z${_zoneIdToName(zoneId)}',
        'state': enable,
      },
    );
  }

  /// Stops all currently running zones.
  /// 
  /// This is equivalent to sending an 'off' command to the special 'all' zone.
  /// Any running schedules will be interrupted.
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - Authentication is required
  Future<void> stopAllZones() async {
    await _get(
      ApiConfig.manualControl,
      {
        'zone': 'all',
        'state': 'off',
      },
    );
  }

  /// Updates the configuration of a specific zone.
  /// 
  /// Parameters:
  /// - [zone]: The zone object containing the updated configuration
  /// 
  /// The update process:
  /// 1. Retrieves all current zones
  /// 2. Updates only the specified zone's parameters
  /// 3. Sends the complete zone configuration to maintain consistency
  /// 
  /// Configurable parameters:
  /// - Zone name
  /// - Enabled state
  /// - Pump association
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - Authentication is required
  /// - The zone ID is invalid
  Future<void> updateZone(Zone zone) async {
    // First get all current zones
    final zones = await getZones();
    
    // Create parameters for all zones
    final params = <String, dynamic>{};
    for (final z in zones) {
      final zoneId = _zoneIdToName(z.id);
      // Use the updated values for the zone being modified, otherwise use existing values
      if (z.id == zone.id) {
        params['z${zoneId}name'] = zone.name;
        params['z${zoneId}e'] = zone.isEnabled;
        params['z${zoneId}p'] = zone.isPumpAssociated;
      } else {
        params['z${zoneId}name'] = z.name;
        params['z${zoneId}e'] = z.isEnabled;
        params['z${zoneId}p'] = z.isPumpAssociated;
      }
    }

    await _get(ApiConfig.setZones, params);
  }

  /// Retrieves a list of all configured schedules.
  /// 
  /// Returns a list of [ApiScheduleListItem] objects containing basic schedule information:
  /// - Schedule ID
  /// - Name
  /// - Enabled state
  /// - Next run time description
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - The response format is invalid
  /// - Authentication is required
  Future<List<ApiScheduleListItem>> getSchedules() async {
    final response = await _get(ApiConfig.schedules);
    return ApiScheduleList.fromJson(response).table;
  }

  /// Retrieves detailed information for a specific schedule.
  /// 
  /// Parameters:
  /// - [id]: The schedule ID to retrieve
  /// 
  /// Returns an [ApiScheduleDetail] object containing:
  /// - Basic schedule information (name, enabled state)
  /// - Schedule type (day-based or interval)
  /// - Run days or interval configuration
  /// - Start times
  /// - Zone run times
  /// - Weather adjustment setting
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - The response format is invalid
  /// - Authentication is required
  /// - The schedule ID is invalid
  Future<ApiScheduleDetail> getSchedule(int id) async {
    final response = await _get(ApiConfig.schedule, {'id': id});
    return ApiScheduleDetail.fromJson(response);
  }

  /// Deletes a schedule from the system.
  /// 
  /// Parameters:
  /// - [id]: The ID of the schedule to delete
  /// 
  /// If the schedule is currently running, it will be stopped.
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - Authentication is required
  /// - The schedule ID is invalid
  Future<void> deleteSchedule(int id) async {
    await _get(ApiConfig.deleteSchedule, {'id': id});
  }

  /// Creates a new schedule or updates an existing one.
  /// 
  /// Parameters:
  /// - [schedule]: The schedule object containing all configuration
  /// 
  /// For new schedules:
  /// - The ID should be null
  /// - A new ID will be assigned by the system
  /// 
  /// For existing schedules:
  /// - The ID must match an existing schedule
  /// - All fields will be updated
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - Authentication is required
  /// - The schedule configuration is invalid
  /// - For updates: the schedule ID doesn't exist
  Future<void> saveSchedule(app_model.ScheduleDetail schedule) async {
    final params = schedule.toApiParams();
    await _get(ApiConfig.setSchedule, params.map(
      (key, value) => MapEntry(key, value.toString()),
    ));
  }

  /// Retrieves current weather conditions and adjustment data.
  /// 
  /// Returns an [ApiWeatherCheck] object containing:
  /// - Weather provider status
  /// - Current temperature, humidity, and precipitation
  /// - Wind speed and UV index
  /// - Watering adjustment scale
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - The response format is invalid
  /// - Authentication is required
  /// - Weather provider is not configured
  Future<ApiWeatherCheck> getWeatherCheck() async {
    final response = await _get(ApiConfig.weatherCheck);
    return ApiWeatherCheck.fromJson(response);
  }

  /// Executes a quick schedule immediately.
  /// 
  /// Parameters:
  /// - [request]: Contains either a schedule ID or custom zone durations
  /// 
  /// For existing schedules:
  /// - Set schedule ID to run it immediately
  /// 
  /// For custom schedules:
  /// - Set schedule ID to -1
  /// - Provide durations for ALL enabled zones
  /// - Missing zone durations retain previous values
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - Authentication is required
  /// - The schedule ID is invalid
  /// - Zone durations are invalid
  Future<void> executeQuickSchedule(ApiQuickScheduleRequest request) async {
    try {
      await _get(ApiConfig.quickSchedule, request.toParams());
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to execute quick schedule: ${e.toString()}');
    }
  }

  /// Retrieves system logs with optional filtering and grouping.
  /// 
  /// Parameters:
  /// - [startDate]: Optional start date for filtering logs
  /// - [endDate]: Optional end date for filtering logs
  /// - [grouping]: How to group the log entries (default: none)
  /// 
  /// Returns an [ApiLogResponse] containing:
  /// - Log entries matching the criteria
  /// - Grouped by the specified method if requested
  /// 
  /// Dates are converted to Unix timestamps (seconds) for the API.
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - The response format is invalid
  /// - Authentication is required
  /// - Date range is invalid
  Future<ApiLogResponse> getLogs({
    DateTime? startDate,
    DateTime? endDate,
    LogGrouping grouping = LogGrouping.none,
  }) async {
    try {
      final params = <String, dynamic>{
        'g': grouping.value,
      };

      if (startDate != null) {
        params['sdate'] = startDate;
      }
      if (endDate != null) {
        params['edate'] = endDate;
      }

      final response = await _get(ApiConfig.logs, params);
      return ApiLogResponse.fromJson(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to get logs: ${e.toString()}');
    }
  }

  /// Retrieves system logs in table format with optional date range.
  /// 
  /// Parameters:
  /// - [startDate]: Optional start date for filtering logs
  /// - [endDate]: Optional end date for filtering logs
  /// 
  /// Returns an [ApiLogResponse] containing:
  /// - Log entries in table format
  /// - One entry per row
  /// - All fields expanded
  /// 
  /// Dates are converted to Unix timestamps (seconds) for the API.
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - The response format is invalid
  /// - Authentication is required
  /// - Date range is invalid
  Future<ApiLogResponse> getTableLogs({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final params = <String, dynamic>{};

      if (startDate != null) {
        params['sdate'] = startDate;
      }
      if (endDate != null) {
        params['edate'] = endDate;
      }

      final response = await _get(ApiConfig.tableLogs, params);
      return ApiLogResponse.fromJson(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to get table logs: ${e.toString()}');
    }
  }

  /// Restarts all system services while maintaining current settings.
  /// 
  /// This operation:
  /// - Stops all running zones
  /// - Restarts the irrigation service
  /// - Preserves all schedules and settings
  /// - Re-initializes all subsystems
  /// 
  /// Use this to recover from system issues or after major configuration changes.
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - Authentication is required
  /// - The system is in a state that prevents reset
  Future<void> resetSystem() async {
    try {
      await _get(ApiConfig.systemReset);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to reset system: ${e.toString()}');
    }
  }

  /// Resets all settings to factory defaults.
  /// 
  /// This operation:
  /// - Deletes all schedules
  /// - Resets all zone configurations
  /// - Clears weather settings
  /// - Resets system options
  /// - Restarts all services
  /// 
  /// WARNING: This is a destructive operation that cannot be undone.
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - Authentication is required
  /// - The system is in a state that prevents reset
  Future<void> factoryReset() async {
    try {
      await _get(ApiConfig.factoryReset);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to factory reset: ${e.toString()}');
    }
  }

  /// Tests system communication with a specific zone.
  /// 
  /// Parameters:
  /// - [zoneId]: Zero-based zone ID to test
  /// - [state]: Desired test state (on/off)
  /// 
  /// This operation:
  /// - Sends a test message to the specified zone
  /// - Verifies communication path
  /// - Does not affect schedules
  /// - Helps diagnose hardware issues
  /// 
  /// The zone ID is converted to the API's letter-based system:
  /// - 0 -> 'zb'
  /// - 1 -> 'zc'
  /// etc.
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - Authentication is required
  /// - The zone ID is invalid
  /// - Communication test fails
  Future<void> sendChatterMessage({
    required int zoneId,
    required bool state,
  }) async {
    try {
      await _get(
        ApiConfig.chatterBox,
        {
          'zone': 'z${_zoneIdToName(zoneId)}',
          'state': state,
        },
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to send chatter message: ${e.toString()}');
    }
  }

  /// Retrieves all system settings.
  /// 
  /// Returns an [ApiSettings] object containing:
  /// - Network configuration
  /// - Weather provider settings
  /// - System options
  /// - Hardware configuration
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - The response format is invalid
  /// - Authentication is required
  Future<ApiSettings> getSettings() async {
    try {
      final response = await _get(ApiConfig.settings);
      return ApiSettings.fromJson(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to get settings: ${e.toString()}');
    }
  }

  /// Updates system settings.
  /// 
  /// Parameters:
  /// - [settings]: Object containing all settings to update
  /// 
  /// This operation:
  /// - Validates all settings
  /// - Updates only changed values
  /// - May require system restart
  /// - Preserves other configurations
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - Authentication is required
  /// - Settings validation fails
  /// - Network configuration is invalid
  Future<void> saveSettings(app_model.Settings settings) async {
    try {
      final params = settings.toApiParams();
      await _get(ApiConfig.saveSettings, params);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to save settings: ${e.toString()}');
    }
  }

  /// Enables or disables the entire irrigation system.
  /// 
  /// Parameters:
  /// - [enabled]: true to enable, false to disable
  /// 
  /// When disabled:
  /// - All running zones are stopped
  /// - Scheduled operations are suspended
  /// - Manual operations are prevented
  /// - System continues to track time
  /// 
  /// Throws [ApiException] if:
  /// - The request fails
  /// - Authentication is required
  /// - System is in an invalid state
  Future<void> setSystemEnabled(bool enabled) async {
    try {
      await _get(
        ApiConfig.run,
        {
          'system': enabled,
        },
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to ${enabled ? 'enable' : 'disable'} system: ${e.toString()}');
    }
  }
}

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  return ApiClient();
} 