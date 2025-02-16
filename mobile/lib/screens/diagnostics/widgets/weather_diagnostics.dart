import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/weather_provider.dart';

class WeatherDiagnostics extends ConsumerWidget {
  const WeatherDiagnostics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherData = ref.watch(weatherNotifierProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(weatherNotifierProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weather Provider',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  weatherData.when(
                    data: (data) {
                      if (data.noProvider) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status: Not Configured',
                              style: TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Configure weather provider in settings to enable weather-based adjustments.',
                            ),
                          ],
                        );
                      }

                      if (data.keyNotFound) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status: Invalid API Key',
                              style: TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Check your weather provider API key in settings.',
                            ),
                            if (data.resolvedIP != null) ...[
                              const SizedBox(height: 8),
                              Text('Service IP: ${data.resolvedIP}'),
                            ],
                          ],
                        );
                      }

                      if (!data.valid) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status: Invalid Data',
                              style: TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Weather data is not valid. Check your configuration.',
                            ),
                            if (data.resolvedIP != null) ...[
                              const SizedBox(height: 8),
                              Text('Service IP: ${data.resolvedIP}'),
                            ],
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status: Connected',
                            style: TextStyle(color: Colors.green),
                          ),
                          if (data.resolvedIP != null) ...[
                            const SizedBox(height: 8),
                            Text('Service IP: ${data.resolvedIP}'),
                          ],
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, _) => Text(
                      'Error: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      ref.read(weatherNotifierProvider.notifier).refresh();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Test Connection'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Weather Data',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  weatherData.when(
                    data: (data) {
                      if (!data.valid || data.noProvider || data.keyNotFound) {
                        return const Text('No weather data available');
                      }

                      return Column(
                        children: [
                          _buildDataRow(
                            'Temperature',
                            '${data.meanTemperature.toStringAsFixed(1)}°F',
                          ),
                          _buildDataRow(
                            'Humidity',
                            '${data.minHumidity}% - ${data.maxHumidity}%',
                          ),
                          _buildDataRow(
                            'Precipitation (Yesterday)',
                            '${data.precipitation.toStringAsFixed(2)} in',
                          ),
                          _buildDataRow(
                            'Precipitation (Today)',
                            '${data.precipitationToday.toStringAsFixed(2)} in',
                          ),
                          _buildDataRow(
                            'Wind Speed',
                            '${data.windSpeed.toStringAsFixed(1)} mph',
                          ),
                          _buildDataRow(
                            'UV Index',
                            (data.uvIndex / 10).toStringAsFixed(1),
                          ),
                          const Divider(),
                          _buildDataRow(
                            'Watering Adjustment',
                            '${data.scale}%',
                            valueColor: data.scale < 100 
                              ? Colors.red 
                              : data.scale > 100 
                                ? Colors.green 
                                : null,
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, _) => Text(
                      'Error: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: valueColor != null ? FontWeight.w500 : null,
            ),
          ),
        ],
      ),
    );
  }
} 