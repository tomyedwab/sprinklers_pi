import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/zone_provider.dart';
import '../../api/models/zone.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import 'widgets/zone_card.dart';

class ZonesScreen extends ConsumerWidget {
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zonesAsync = ref.watch(zonesNotifierProvider);
    final theme = Theme.of(context);
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Zones',
          style: appTheme.cardTitleStyle,
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: appTheme.scheduleIconColor,
            ),
            onPressed: () => ref.refresh(zonesNotifierProvider),
          ),
        ],
      ),
      body: zonesAsync.when(
        data: (zones) => _ZonesList(zones: zones),
        loading: () => Center(
          child: CircularProgressIndicator(
            color: appTheme.activeZoneColor,
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Failed to load zones',
                style: appTheme.statusTextStyle.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              SizedBox(height: Spacing.md),
              ElevatedButton(
                onPressed: () => ref.refresh(zonesNotifierProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.surface,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZonesList extends ConsumerWidget {
  final List<Zone> zones;

  const _ZonesList({required this.zones});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appTheme = AppTheme.of(context);

    if (zones.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.water_drop_outlined,
              size: 64,
              color: appTheme.inactiveZoneColor,
            ),
            SizedBox(height: Spacing.md),
            Text(
              'No zones configured',
              style: appTheme.cardTitleStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Spacing.xs),
            Text(
              'Add zones to start controlling your sprinklers',
              style: appTheme.subtitleTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: appTheme.activeZoneColor,
      onRefresh: () => ref.refresh(zonesNotifierProvider.future),
      child: ListView.builder(
        padding: Spacing.screenPaddingAll,
        itemCount: zones.length,
        itemBuilder: (context, index) {
          final zone = zones[index];
          return Padding(
            padding: EdgeInsets.only(bottom: Spacing.md),
            child: ZoneCard(
              zone: zone,
              onToggle: (enabled) => ref.read(zonesNotifierProvider.notifier)
                  .toggleZone(zone.id, enabled),
            ),
          );
        },
      ),
    );
  }
} 