import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../providers/zone_provider.dart';
import '../providers/system_state_provider.dart';
import '../api/models/zone.dart';

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

        if (activeZone == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: const [
                  Icon(
                    Icons.water_drop_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No Active Zones',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return systemStateAsync.when(
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
          data: (systemState) {
            final remainingTime = systemState.remainingTime;
            final isManual = remainingTime?.inSeconds == 99999;
            final displayTime = isManual ? remainingTime : _localRemainingTime ?? remainingTime;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Active Zone',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                                    ? 'Remaining: ${displayTime.inMinutes}m ${displayTime.inSeconds % 60}s'
                                    : 'Time remaining unknown',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
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
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Stop'),
                        ),
                      ],
                    ),
                    if (!isManual && displayTime != null) ...[
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: 1 - (displayTime.inSeconds / (displayTime.inSeconds + (DateTime.now().difference(_lastUpdateTime ?? systemState.currentTime).inSeconds))),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
} 