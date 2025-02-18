import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../providers/zone_provider.dart';
import '../providers/system_state_provider.dart';
import '../api/models/zone.dart';
import 'quick_schedule_dialog.dart';

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

    return zonesAsync.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stackTrace) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
      ),
      data: (zones) {
        final activeZone = zones.where((z) => z.state).firstOrNull;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Watering',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (activeZone == null) ...[
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.water_drop_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No Active Zones',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
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
                  ),
                ] else
                  systemStateAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
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
                              const Icon(
                                Icons.water_drop,
                                size: 32,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activeZone.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isManual 
                                        ? 'Manual Mode'
                                        : displayTime != null 
                                          ? 'Time Remaining: ${_formatDuration(displayTime)}'
                                          : 'Time remaining unknown',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontWeight: FontWeight.w500,
                                      ),
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
                                  backgroundColor: Colors.red,
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
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
} 