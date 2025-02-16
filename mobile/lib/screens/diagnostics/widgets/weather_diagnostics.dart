import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/weather_provider.dart';
import '../../../widgets/standard_error_widget.dart';
import '../../../widgets/loading_states.dart';

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
                        return StandardErrorWidget(
                          message: 'Weather provider not configured',
                          type: ErrorType.generic,
                          primaryActionText: 'Configure',
                          onPrimaryAction: () {
                            // TODO: Navigate to settings
                          },
                          secondaryActionText: 'Learn More',
                          onSecondaryAction: () {
                            // TODO: Show documentation
                          },
                        );
                      }

                      if (data.keyNotFound) {
                        return StandardErrorWidget(
                          message: 'Invalid weather provider API key',
                          type: ErrorType.validation,
                          primaryActionText: 'Update Key',
                          onPrimaryAction: () {
                            // TODO: Navigate to settings
                          },
                        );
                      }

                      if (!data.valid) {
                        return StandardErrorWidget(
                          message: 'Invalid response from weather provider',
                          type: ErrorType.network,
                          showRetry: true,
                          onPrimaryAction: () => ref.refresh(weatherNotifierProvider),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: Connected'),
                          const SizedBox(height: 8),
                          Text('Provider IP: ${data.resolvedIP}'),
                          const SizedBox(height: 16),
                          Text('Overall Scale: ${data.scale}%'),
                          const Divider(),
                          const Text(
                            "Yesterday's Values",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Mean Temperature: ${data.meanTemperature}°F'),
                          Text('Humidity: ${data.minHumidity}% - ${data.maxHumidity}%'),
                          Text('Precipitation: ${data.precipitation} inches'),
                          Text('Wind: ${data.windSpeed} mph'),
                          const Divider(),
                          const Text(
                            "Today's Values",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Precipitation: ${data.precipitationToday} inches'),
                          Text('UV Index: ${data.uvIndex}'),
                        ],
                      );
                    },
                    loading: () => const SkeletonCard(
                      height: 300,
                      showHeader: true,
                      contentLines: 8,
                      showActions: false,
                    ),
                    error: (error, stack) => StandardErrorWidget(
                      message: 'Failed to load weather data: $error',
                      type: ErrorType.network,
                      showRetry: true,
                      onPrimaryAction: () => ref.refresh(weatherNotifierProvider),
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
} 