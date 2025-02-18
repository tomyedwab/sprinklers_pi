import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../models/zone.dart';
import '../../providers/zone_provider.dart';
import '../../providers/system_state_provider.dart';
import '../../widgets/active_zone_card.dart';
import '../../widgets/upcoming_schedules_card.dart';
import '../../widgets/weather_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _startRefreshTimer();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startRefreshTimer() {
    // Refresh every 15 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    await Future.wait([
      ref.read(systemStateNotifierProvider.notifier).refresh(),
      ref.read(zonesNotifierProvider.notifier).refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: _refreshData,
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: _refreshData,
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
                  ActiveZoneCard(),
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