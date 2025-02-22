import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../models/weather.dart';
import '../theme/spacing.dart';
import '../theme/app_theme.dart';

class WeatherCard extends ConsumerWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherAutoRefreshProvider);

    return Card(
      child: Stack(
        children: [
          Padding(
            padding: Spacing.cardPaddingAll,
            child: weatherAsync.when(
              data: (weather) => _WeatherContent(weather: weather),
              loading: () => _WeatherLoadingContent(),
              error: (error, stack) => _WeatherError(onRetry: () => ref.refresh(weatherNotifierProvider)),
            ),
          ),
          if (weatherAsync.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.1),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  final Weather weather;

  const _WeatherContent({required this.weather});

  @override
  Widget build(BuildContext context) {
    if (!weather.isFullyConfigured) {
      return const _WeatherNotConfigured();
    }

    final appTheme = AppTheme.of(context);
    final isRaining = weather.precipitation > 0 || weather.precipitationToday > 0;
    final isDaytime = DateTime.now().hour >= 6 && DateTime.now().hour < 20;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weather',
              style: appTheme.cardTitleStyle,
            ),
            Icon(
              isDaytime 
                ? (isRaining ? Icons.water : Icons.wb_sunny)
                : (isRaining ? Icons.water_drop : Icons.nightlight),
              color: appTheme.weatherIconColor,
              size: 24,
            ),
          ],
        ),
        SizedBox(height: Spacing.contentSpacing),
        Row(
          children: [
            Expanded(
              child: _WeatherTile(
                icon: Icons.thermostat,
                label: 'Temperature',
                value: '${weather.meanTemperature.round()}°F',
              ),
            ),
            Expanded(
              child: _WeatherTile(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: '${(weather.minHumidity + weather.maxHumidity) ~/ 2}%',
              ),
            ),
          ],
        ),
        SizedBox(height: Spacing.contentSpacing),
        Row(
          children: [
            Expanded(
              child: _WeatherTile(
                icon: Icons.umbrella,
                label: 'Rain',
                value: '${(weather.precipitation + weather.precipitationToday).toStringAsFixed(2)}in',
                subtitle: isRaining ? 'Recent rainfall detected' : null,
              ),
            ),
            Expanded(
              child: _WeatherTile(
                icon: Icons.air,
                label: 'Wind',
                value: '${weather.windSpeed.round()} mph',
                subtitle: weather.windSpeed > 10 ? 'High wind conditions' : null,
              ),
            ),
          ],
        ),
        SizedBox(height: Spacing.contentSpacing),
        _WeatherTile(
          icon: Icons.wb_sunny,
          label: 'UV Index',
          value: (weather.uvIndex / 10).toStringAsFixed(1),
          subtitle: _getUVDescription(weather.uvIndex / 10),
        ),
        SizedBox(height: Spacing.contentSpacing),
        const Divider(),
        SizedBox(height: Spacing.contentSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Watering Adjustment',
                    style: appTheme.cardTitleStyle,
                  ),
                  SizedBox(height: Spacing.contentSpacing),
                  Text(
                    'Based on current conditions, watering times will be ${weather.scale < 100 ? 'reduced' : (weather.scale > 100 ? 'increased' : 'unchanged')}.',
                    style: appTheme.statusTextStyle,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: appTheme.weatherIconColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${weather.scale}%',
                style: appTheme.valueTextStyle.copyWith(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        if (weather.scale != 100) ...[
          SizedBox(height: Spacing.contentSpacing),
          Text(
            weather.scale < 100
              ? 'Recent rainfall and humidity levels have reduced the need for watering.'
              : 'Hot and dry conditions have increased the need for watering.',
            style: appTheme.subtitleTextStyle,
          ),
        ],
      ],
    );
  }

  String _getUVDescription(double uv) {
    if (uv >= 11) return 'Extreme';
    if (uv >= 8) return 'Very High';
    if (uv >= 6) return 'High';
    if (uv >= 3) return 'Moderate';
    return 'Low';
  }
}

class _WeatherLoadingContent extends StatelessWidget {
  const _WeatherLoadingContent();

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final isDaytime = DateTime.now().hour >= 6 && DateTime.now().hour < 20;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weather',
              style: appTheme.cardTitleStyle,
            ),
            Icon(
              isDaytime ? Icons.wb_sunny : Icons.nightlight,
              color: appTheme.weatherIconColor,
              size: 24,
            ),
          ],
        ),
        SizedBox(height: Spacing.contentSpacing),
        Row(
          children: [
            Expanded(
              child: _WeatherTile(
                icon: Icons.thermostat,
                label: 'Temperature',
                value: '-°F',
              ),
            ),
            Expanded(
              child: _WeatherTile(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: '-%',
              ),
            ),
          ],
        ),
        SizedBox(height: Spacing.contentSpacing),
        Row(
          children: [
            Expanded(
              child: _WeatherTile(
                icon: Icons.umbrella,
                label: 'Rain',
                value: '-in',
              ),
            ),
            Expanded(
              child: _WeatherTile(
                icon: Icons.air,
                label: 'Wind',
                value: '- mph',
              ),
            ),
          ],
        ),
        SizedBox(height: Spacing.contentSpacing),
        _WeatherTile(
          icon: Icons.wb_sunny,
          label: 'UV Index',
          value: '-',
          subtitle: '-',
        ),
        SizedBox(height: Spacing.contentSpacing),
        const Divider(),
        SizedBox(height: Spacing.contentSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Watering Adjustment',
                    style: appTheme.cardTitleStyle,
                  ),
                  SizedBox(height: Spacing.contentSpacing),
                  Text(
                    'Loading watering adjustment...',
                    style: appTheme.statusTextStyle,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: appTheme.weatherIconColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '-%',
                style: appTheme.valueTextStyle.copyWith(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WeatherTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;

  const _WeatherTile({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    
    return Row(
      children: [
        Icon(icon, size: 24, color: appTheme.weatherIconColor),
        SizedBox(width: Spacing.contentSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: appTheme.statusTextStyle),
              Text(value, style: appTheme.valueTextStyle),
              if (subtitle != null)
                Text(subtitle!, style: appTheme.subtitleTextStyle),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeatherError extends StatelessWidget {
  final VoidCallback onRetry;

  const _WeatherError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Failed to load weather data', style: appTheme.statusTextStyle),
          SizedBox(height: Spacing.contentSpacing),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _WeatherNotConfigured extends StatelessWidget {
  const _WeatherNotConfigured();

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.cloud_off,
          size: 48,
          color: appTheme.disabledStateColor,
        ),
        SizedBox(height: Spacing.contentSpacing),
        Text(
          'Weather Provider Not Configured',
          style: appTheme.cardTitleStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Spacing.contentSpacing),
        Text(
          'Configure weather settings to enable automatic adjustments',
          style: appTheme.statusTextStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} 