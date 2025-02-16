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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              // TODO: Implement refresh functionality
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () async {
          // TODO: Implement pull-to-refresh functionality
        },
        child: isWideScreen
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main content (60% width)
                  Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          ActiveZoneCard(),
                          SizedBox(height: 16),
                          QuickActionsCard(),
                          SizedBox(height: 16),
                          WeatherCard(),
                        ],
                      ),
                    ),
                  ),
                  // Side panel (40% width)
                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          SystemStatusCard(),
                          SizedBox(height: 16),
                          UpcomingSchedulesCard(),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : ListView(
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