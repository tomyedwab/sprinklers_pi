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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(zonesNotifierProvider),
          ),
        ],
      ),
      body: zonesAsync.when(
        data: (zones) => _ZonesList(zones: zones),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load zones'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(zonesNotifierProvider),
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
    if (zones.isEmpty) {
      return const Center(
        child: Text('No zones configured'),
      );
    }

    return RefreshIndicator(
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