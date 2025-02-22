import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../models/zone.dart';
import '../../providers/zone_provider.dart';
import '../../providers/system_state_provider.dart';
import '../../widgets/active_zone_card.dart';
import '../../widgets/upcoming_schedules_card.dart';
import '../../widgets/weather_card.dart';
import '../../theme/spacing.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Timer? _refreshTimer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Cancel any existing timer before starting a new one
    _refreshTimer?.cancel();
    _startRefreshTimer();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startRefreshTimer() {
    // Cancel any existing timer before creating a new one
    _refreshTimer?.cancel();
    // Refresh every 15 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _refreshData();
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Theme.of(context).colorScheme.onError,
          onPressed: _refreshData,
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
    });

    try {
      final systemStateNotifier = ref.read(systemStateNotifierProvider.notifier);
      final zonesNotifier = ref.read(zonesNotifierProvider.notifier);

      // Refresh system state
      try {
        await systemStateNotifier.refresh();
      } catch (e) {
        _showError('Failed to refresh system state');
      }

      // Refresh zones
      try {
        await zonesNotifier.refresh();
      } catch (e) {
        _showError('Failed to refresh zones');
      }
    } catch (e) {
      // Handle unexpected errors
      _showError('Failed to refresh dashboard');
    }

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  Widget _buildDashboardContent(bool isWideScreen) {
    final systemState = ref.watch(systemStateNotifierProvider);
    final zones = ref.watch(zonesNotifierProvider);

    // Only show loading state if both providers are in their initial loading state
    final isLoading = systemState.isLoading && !systemState.hasValue ||
                     zones.isLoading && !zones.hasValue;

    if (isWideScreen) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content (60% width)
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              padding: Spacing.screenPaddingAll,
              child: Column(
                children: [
                  const ActiveZoneCard(),
                  SizedBox(height: Spacing.cardSpacing),
                  const WeatherCard(),
                ],
              ),
            ),
          ),
          // Side panel (40% width)
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              padding: Spacing.screenPaddingAll,
              child: Column(
                children: [
                  const UpcomingSchedulesCard(),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: Spacing.screenPaddingAll,
      children: [
        const ActiveZoneCard(),
        SizedBox(height: Spacing.cardSpacing),
        const UpcomingSchedulesCard(),
        SizedBox(height: Spacing.cardSpacing),
        const WeatherCard(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > Spacing.wideScreenBreakpoint;

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
            icon: Stack(
              children: [
                Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                if (_isRefreshing)
                  Positioned.fill(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _isRefreshing ? null : _refreshData,
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: _refreshData,
        child: _buildDashboardContent(isWideScreen),
      ),
    );
  }
} 