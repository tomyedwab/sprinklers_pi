import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/schedule.dart';
import '../models/zone.dart';
import '../providers/quick_schedule_provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/zone_provider.dart';

class QuickScheduleDialog extends ConsumerStatefulWidget {
  const QuickScheduleDialog({super.key});

  @override
  ConsumerState<QuickScheduleDialog> createState() => _QuickScheduleDialogState();
}

class _QuickScheduleDialogState extends ConsumerState<QuickScheduleDialog> {
  bool _isCustomSchedule = true;
  String? _selectedScheduleId;
  final Map<String, int> _zoneDurations = {};

  @override
  Widget build(BuildContext context) {
    final schedules = ref.watch(scheduleListNotifierProvider);
    final zones = ref.watch(zonesNotifierProvider);

    return AlertDialog(
      title: const Text('Quick Schedule'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Schedule selection
            DropdownButtonFormField<String>(
              value: _selectedScheduleId,
              decoration: const InputDecoration(
                labelText: 'Schedule to Run',
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Custom'),
                ),
                ...schedules.when(
                  data: (schedules) => schedules.map(
                    (schedule) => DropdownMenuItem(
                      value: schedule.id.toString(),
                      child: Text(schedule.name + (schedule.isEnabled ? '' : ' (disabled)')),
                    ),
                  ).toList(),
                  loading: () => [],
                  error: (_, __) => [],
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedScheduleId = value;
                  _isCustomSchedule = value == null;
                });
              },
            ),
            const SizedBox(height: 16),
            // Zone durations (only shown for custom schedule)
            if (_isCustomSchedule) ...[
              const Text('Zone Durations'),
              const SizedBox(height: 8),
              ...zones.when(
                data: (zones) => zones
                    .where((zone) => zone.isEnabled)
                    .map(
                      (zone) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('${zone.id + 1}: ${zone.name}'),
                            ),
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Minutes',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                initialValue: _zoneDurations[zone.id.toString()] ?.toString() ?? '0',
                                onChanged: (value) {
                                  final duration = int.tryParse(value) ?? 0;
                                  if (duration >= 0 && duration <= 255) {
                                    setState(() {
                                      _zoneDurations[zone.id.toString()] = duration;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                loading: () => [const CircularProgressIndicator()],
                error: (_, __) => [const Text('Failed to load zones')],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            final quickSchedule = ref.read(quickScheduleProvider);
            try {
              if (_isCustomSchedule) {
                await quickSchedule.executeCustomSchedule(_zoneDurations);
              } else if (_selectedScheduleId != null) {
                await quickSchedule.executeSchedule(_selectedScheduleId!);
              }
              if (mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quick schedule started')),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to start quick schedule: $e')),
                );
              }
            }
          },
          child: const Text('Start'),
        ),
      ],
    );
  }
} 