import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/schedule.dart';
import '../models/zone.dart';
import '../providers/quick_schedule_provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/zone_provider.dart';
import '../providers/system_state_provider.dart';
import '../theme/spacing.dart';
import '../theme/app_theme.dart';

class QuickScheduleDialog extends ConsumerStatefulWidget {
  const QuickScheduleDialog({super.key});

  @override
  ConsumerState<QuickScheduleDialog> createState() => _QuickScheduleDialogState();
}

class _QuickScheduleDialogState extends ConsumerState<QuickScheduleDialog> {
  bool _isCustomSchedule = true;
  String? _selectedScheduleId;
  final Map<String, int> _zoneDurations = {};

  bool get _isValid {
    if (!_isCustomSchedule) {
      return _selectedScheduleId != null;
    }
    // Check if any zone has a duration > 0
    return _zoneDurations.values.any((duration) => duration > 0);
  }

  @override
  Widget build(BuildContext context) {
    final schedules = ref.watch(scheduleListNotifierProvider);
    final zones = ref.watch(zonesNotifierProvider);
    final appTheme = AppTheme.of(context);
    final theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: EdgeInsets.all(Spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text('Quick Schedule', style: appTheme.cardTitleStyle),
              SizedBox(height: Spacing.md),

              // Schedule selection
              DropdownButtonFormField<String>(
                value: _selectedScheduleId,
                decoration: InputDecoration(
                  labelText: 'Schedule to Run',
                  border: const OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs,
                  ),
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
                        child: Text(
                          schedule.name + (schedule.isEnabled ? '' : ' (disabled)'),
                          style: schedule.isEnabled 
                              ? appTheme.valueTextStyle 
                              : appTheme.valueTextStyle.copyWith(color: appTheme.mutedTextColor),
                        ),
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
              SizedBox(height: Spacing.md),

              // Zone durations (only shown for custom schedule)
              if (_isCustomSchedule) ...[
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(Spacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Zone Durations', style: theme.textTheme.titleMedium),
                        SizedBox(height: Spacing.sm),
                        zones.when(
                          data: (zones) {
                            // Get list of enabled zones
                            final enabledZones = zones.where((z) => z.isEnabled).toList();
                            
                            if (enabledZones.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'No enabled zones available.\nEnable zones in the Zones tab.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ...enabledZones.map((zone) {
                                  final index = zones.indexOf(zone);
                                  final duration = _zoneDurations[zone.id.toString()] ?? 0;
                                  
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: duration > 0,
                                          onChanged: (value) {
                                            setState(() {
                                              _zoneDurations[zone.id.toString()] = value == true ? 15 : 0;
                                            });
                                          },
                                        ),
                                        Expanded(
                                          child: Text(zone.name),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: TextFormField(
                                            initialValue: duration.toString(),
                                            keyboardType: TextInputType.number,
                                            enabled: duration > 0,
                                            decoration: const InputDecoration(
                                              suffixText: 'min',
                                              isDense: true,
                                            ),
                                            onChanged: (value) {
                                              final minutes = int.tryParse(value) ?? 0;
                                              setState(() {
                                                _zoneDurations[zone.id.toString()] = minutes.clamp(0, 255);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (error, stack) => Center(
                            child: Text(
                              'Failed to load zones: $error',
                              style: appTheme.statusTextStyle.copyWith(color: appTheme.disabledStateColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              SizedBox(height: Spacing.md),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: Spacing.xs),
                  FilledButton(
                    onPressed: _isValid ? () async {
                      final quickSchedule = ref.read(quickScheduleProvider);
                      try {
                        if (_isCustomSchedule) {
                          await quickSchedule.executeCustomSchedule(_zoneDurations);
                        } else if (_selectedScheduleId != null) {
                          await quickSchedule.executeSchedule(_selectedScheduleId!);
                        }
                        // Refresh state after starting schedule
                        ref.read(systemStateNotifierProvider.notifier).refresh();
                        if (mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: theme.colorScheme.surface,
                              content: Text(
                                'Quick schedule started',
                                style: appTheme.statusTextStyle.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: theme.colorScheme.errorContainer,
                              content: Text(
                                'Failed to start quick schedule: $e',
                                style: appTheme.statusTextStyle.copyWith(
                                  color: theme.colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          );
                        }
                      }
                    } : null,
                    child: const Text('Start'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 