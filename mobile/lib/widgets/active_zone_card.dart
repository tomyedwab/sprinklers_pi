import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../providers/zone_provider.dart';
import '../providers/system_state_provider.dart';
import '../api/models/zone.dart';
import 'quick_schedule_dialog.dart';
import '../theme/spacing.dart';
import '../theme/app_theme.dart';

class ActiveZoneCard extends ConsumerStatefulWidget {
  const ActiveZoneCard({super.key});

  @override
  ConsumerState<ActiveZoneCard> createState() => _ActiveZoneCardState();
}

class _ActiveZoneCardState extends ConsumerState<ActiveZoneCard> {
  Timer? _timer;
  Duration? _localRemainingTime;
  DateTime? _lastUpdateTime;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(Duration initialTime, DateTime currentTime) {
    _timer?.cancel();
    _localRemainingTime = initialTime;
    _lastUpdateTime = currentTime;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_localRemainingTime != null && _localRemainingTime!.inSeconds > 0) {
            _localRemainingTime = _localRemainingTime! - const Duration(seconds: 1);
          } else {
            _timer?.cancel();
          }
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${(duration.inMinutes % 60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${(duration.inSeconds % 60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  Future<void> _refreshState() async {
    await Future.wait([
      ref.read(systemStateNotifierProvider.notifier).refresh(),
      ref.read(zonesNotifierProvider.notifier).refresh(),
    ]);
  }

  Widget _buildNoActiveZones() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.water_drop_outlined,
            size: 48,
            color: AppTheme.of(context).inactiveZoneColor,
          ),
          const SizedBox(height: 8),
          Text(
            'No Active Zones',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.of(context).inactiveZoneColor,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => const QuickScheduleDialog(),
              );
              await _refreshState();
            },
            icon: const Icon(Icons.play_circle_outline),
            label: const Text('Quick Run'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final zonesAsync = ref.watch(zonesNotifierProvider);
    final systemStateAsync = ref.watch(systemStateNotifierProvider);

    // Reset timer when system state changes
    ref.listen(systemStateNotifierProvider, (previous, next) {
      next.whenData((systemState) {
        if (systemState.remainingTime != null) {
          _startTimer(systemState.remainingTime!, systemState.currentTime);
        }
      });
    });

    return Card(
      child: Stack(
        children: [
          Padding(
            padding: Spacing.cardPaddingAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Zone',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: Spacing.contentSpacing),
                zonesAsync.when(
                  loading: () => _buildNoActiveZones(),
                  error: (error, stackTrace) => Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Error: ${error.toString()}',
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  data: (zones) {
                    final activeZone = zones.where((z) => z.state).firstOrNull;
                    if (activeZone == null) {
                      return _buildNoActiveZones();
                    }

                    return systemStateAsync.when(
                      loading: () => _buildNoActiveZones(),
                      error: (error, stackTrace) => Center(
                        child: Text('Error: ${error.toString()}'),
                      ),
                      data: (systemState) {
                        final remainingTime = systemState.remainingTime;
                        final isManual = remainingTime?.inSeconds == 99999;
                        final displayTime = isManual ? remainingTime : _localRemainingTime ?? remainingTime;

                        return Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.water_drop,
                                  size: 32,
                                  color: AppTheme.of(context).activeZoneColor,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activeZone.name,
                                        style: AppTheme.of(context).valueTextStyle,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        isManual 
                                          ? 'Manual Mode'
                                          : displayTime != null 
                                            ? 'Time Remaining: ${_formatDuration(displayTime)}'
                                            : 'Time remaining unknown',
                                        style: AppTheme.of(context).subtitleTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    _timer?.cancel(); // Cancel timer when stopping zone
                                    await ref.read(zonesNotifierProvider.notifier)
                                        .toggleZone(activeZone.id, false);
                                    await _refreshState();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.of(context).disabledStateColor,
                                  ),
                                  child: const Text('Stop'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) => const QuickScheduleDialog(),
                                );
                                await _refreshState();
                              },
                              icon: const Icon(Icons.play_circle_outline),
                              label: const Text('Quick Run'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          if (zonesAsync.isLoading || systemStateAsync.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.1),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 