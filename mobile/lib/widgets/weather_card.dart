import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../models/weather.dart';

class WeatherCard extends ConsumerWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherAutoRefreshProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: weatherAsync.when(
          data: (weather) => _WeatherContent(weather: weather),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _WeatherError(onRetry: () => ref.refresh(weatherNotifierProvider)),
        ),
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

    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Weather', style: theme.textTheme.titleLarge),
            Text('${weather.scale}% Adjustment',
                style: theme.textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _WeatherTile(
                icon: Icons.umbrella,
                label: 'Rain',
                value: '${(weather.precipitation + weather.precipitationToday).toStringAsFixed(2)}in',
              ),
            ),
            Expanded(
              child: _WeatherTile(
                icon: Icons.air,
                label: 'Wind',
                value: '${weather.windSpeed.round()} mph',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _WeatherTile(
          icon: Icons.wb_sunny,
          label: 'UV Index',
          value: (weather.uvIndex / 10).toStringAsFixed(1),
          subtitle: _getUVDescription(weather.uvIndex / 10),
        ),
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
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodyMedium),
              Text(value, style: theme.textTheme.titleMedium),
              if (subtitle != null)
                Text(subtitle!, style: theme.textTheme.bodySmall),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Failed to load weather data'),
          const SizedBox(height: 8),
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
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.cloud_off, size: 48),
        const SizedBox(height: 16),
        Text(
          'Weather Provider Not Configured',
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Configure weather settings to enable automatic adjustments',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} 