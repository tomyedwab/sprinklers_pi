import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherCard extends ConsumerWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Connect to actual weather provider
    final temperature = 72;
    final humidity = 45;
    final rainChance = 10;
    final windSpeed = 5;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                TextButton.icon(
                  onPressed: () {
                    // TODO: Implement refresh weather
                  },
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text('Refresh'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherItem(
                  icon: Icons.thermostat,
                  value: '$temperature°F',
                  label: 'Temperature',
                ),
                _buildWeatherItem(
                  icon: Icons.water_drop,
                  value: '$humidity%',
                  label: 'Humidity',
                ),
                _buildWeatherItem(
                  icon: Icons.umbrella,
                  value: '$rainChance%',
                  label: 'Rain Chance',
                ),
                _buildWeatherItem(
                  icon: Icons.air,
                  value: '$windSpeed mph',
                  label: 'Wind',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last Updated: ${_formatLastUpdated(DateTime.now())}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to detailed weather view
                  },
                  child: const Text('View Forecast'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  String _formatLastUpdated(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
} 