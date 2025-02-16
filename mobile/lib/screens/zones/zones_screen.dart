import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/zone_provider.dart';
import '../../api/models/zone.dart';
import 'widgets/zone_card.dart';

class ZonesScreen extends ConsumerWidget {
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zonesAsync = ref.watch(zonesNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Zones',
          style: theme.textTheme.titleLarge,
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: theme.colorScheme.secondary,
            ),
            onPressed: () => ref.refresh(zonesNotifierProvider),
          ),
        ],
      ),
      body: zonesAsync.when(
        data: (zones) => _ZonesList(zones: zones),
        loading: () => Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Failed to load zones',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 16),
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

    if (zones.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.water_drop_outlined,
              size: 64,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No zones configured',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add zones to start controlling your sprinklers',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: theme.colorScheme.primary,
      onRefresh: () => ref.refresh(zonesNotifierProvider.future),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: zones.length,
        itemBuilder: (context, index) {
          final zone = zones[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ZoneCard(
              zone: zone,
              onToggle: (enabled) {
                ref.read(zonesNotifierProvider.notifier)
                    .toggleZone(zone.id, enabled);
              },
              onEdit: () {
                // TODO: Navigate to zone edit screen
                // This will be implemented in a separate task
              },
            ),
          );
        },
      ),
    );
  }
} 