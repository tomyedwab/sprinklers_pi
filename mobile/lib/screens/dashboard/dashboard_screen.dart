import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/zone.dart';
import '../../providers/zone_provider.dart';
import '../../widgets/system_status_card.dart';
import '../../widgets/active_zone_card.dart';
import '../../widgets/upcoming_schedules_card.dart';
import '../../widgets/weather_card.dart';
import '../../widgets/quick_actions_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Implement refresh functionality
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement pull-to-refresh functionality
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [
            SystemStatusCard(),
            SizedBox(height: 16),
            ActiveZoneCard(),
            SizedBox(height: 16),
            QuickActionsCard(),
            SizedBox(height: 16),
            UpcomingSchedulesCard(),
            SizedBox(height: 16),
            WeatherCard(),
          ],
        ),
      ),
    );
  }
} 