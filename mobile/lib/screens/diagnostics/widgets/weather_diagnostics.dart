import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/weather_provider.dart';
import '../../../widgets/standard_error_widget.dart';
import '../../../widgets/loading_states.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/spacing.dart';

class WeatherDiagnostics extends ConsumerWidget {
  const WeatherDiagnostics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherData = ref.watch(weatherNotifierProvider);
    final appTheme = AppTheme.of(context);

    return RefreshIndicator(
      onRefresh: () => ref.read(weatherNotifierProvider.notifier).refresh(),
      child: ListView(
        padding: Spacing.screenPaddingAll,
        children: [
          Card(
            child: Padding(
              padding: Spacing.cardPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weather Provider',
                    style: appTheme.cardTitleStyle,
                  ),
                  SizedBox(height: Spacing.md),
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
                          _buildInfoRow(context, 'Status', 'Connected'),
                          _buildInfoRow(context, 'Provider IP', data.resolvedIP ?? 'Unknown'),
                          _buildInfoRow(context, 'Overall Scale', '${data.scale}%'),
                          const Divider(),
                          Text(
                            "Yesterday's Values",
                            style: appTheme.cardTitleStyle,
                          ),
                          SizedBox(height: Spacing.xs),
                          _buildInfoRow(context, 'Mean Temperature', '${data.meanTemperature}°F'),
                          _buildInfoRow(context, 'Humidity', '${data.minHumidity}% - ${data.maxHumidity}%'),
                          _buildInfoRow(context, 'Precipitation', '${data.precipitation} inches'),
                          _buildInfoRow(context, 'Wind', '${data.windSpeed} mph'),
                          const Divider(),
                          Text(
                            "Today's Values",
                            style: appTheme.cardTitleStyle,
                          ),
                          SizedBox(height: Spacing.xs),
                          _buildInfoRow(context, 'Precipitation', '${data.precipitationToday} inches'),
                          _buildInfoRow(context, 'UV Index', data.uvIndex.toString()),
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

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final appTheme = AppTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Spacing.unit),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: appTheme.subtitleTextStyle,
          ),
          Text(
            value,
            style: appTheme.valueTextStyle,
          ),
        ],
      ),
    );
  }
} 