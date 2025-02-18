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
    final isRaining = weather.precipitation > 0 || weather.precipitationToday > 0;
    final isDaytime = DateTime.now().hour >= 6 && DateTime.now().hour < 20;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Weather',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              isDaytime 
                ? (isRaining ? Icons.water : Icons.wb_sunny)
                : (isRaining ? Icons.water_drop : Icons.nightlight),
              color: theme.colorScheme.primary,
              size: 24,
            ),
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
        const SizedBox(height: 8),
        _WeatherTile(
          icon: Icons.wb_sunny,
          label: 'UV Index',
          value: (weather.uvIndex / 10).toStringAsFixed(1),
          subtitle: _getUVDescription(weather.uvIndex / 10),
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Watering Adjustment',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Based on current conditions, watering times will be ${weather.scale < 100 ? 'reduced' : (weather.scale > 100 ? 'increased' : 'unchanged')}.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${weather.scale}%',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.surface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        if (weather.scale != 100) ...[
          const SizedBox(height: 8),
          Text(
            weather.scale < 100
              ? 'Recent rainfall and humidity levels have reduced the need for watering.'
              : 'Hot and dry conditions have increased the need for watering.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontStyle: FontStyle.italic,
            ),
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
        Icon(icon, size: 24, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodyMedium),
              Text(
                value, 
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!, 
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
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
    final theme = Theme.of(context);
    
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
        Icon(
          Icons.cloud_off,
          size: 48,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: 16),
        Text(
          'Weather Provider Not Configured',
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Configure weather settings to enable automatic adjustments',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} 