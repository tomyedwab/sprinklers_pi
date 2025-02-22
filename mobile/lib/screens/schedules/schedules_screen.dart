import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/schedule_zone_provider.dart';
import '../../models/schedule.dart';
import '../../widgets/loading_states.dart';
import '../../widgets/confirmation_dialogs.dart';
import '../../widgets/standard_error_widget.dart';
import '../../widgets/zone_toggle_widget.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';
import 'widgets/schedule_edit_modal.dart';

/// State for tracking schedule toggle operations
enum ScheduleToggleState {
  data,
  loading,
  error;

  bool get isLoading => this == ScheduleToggleState.loading;
  bool get isError => this == ScheduleToggleState.error;
  bool get isData => this == ScheduleToggleState.data;
}

/// Provider for managing schedule toggle state
final scheduleToggleStateProvider = StateNotifierProvider.family<ScheduleToggleStateNotifier, ScheduleToggleState, int>(
  (ref, scheduleId) => ScheduleToggleStateNotifier(),
);

/// Notifier for schedule toggle state
class ScheduleToggleStateNotifier extends StateNotifier<ScheduleToggleState> {
  ScheduleToggleStateNotifier() : super(ScheduleToggleState.data);

  void startLoading() => state = ScheduleToggleState.loading;
  void setSuccess() => state = ScheduleToggleState.data;
  void setError() => state = ScheduleToggleState.error;
}

class SchedulesScreen extends ConsumerWidget {
  const SchedulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(scheduleListNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Schedules',
          style: theme.textTheme.titleLarge,
        ),
        elevation: 2,
      ),
      body: schedulesAsync.when(
        data: (schedules) => schedules.isEmpty
            ? const _EmptyScheduleList()
            : ListView.separated(
                padding: EdgeInsets.all(Spacing.md),
                itemCount: schedules.length,
                separatorBuilder: (context, index) => SizedBox(height: Spacing.xs),
                itemBuilder: (context, index) => _ScheduleListCard(
                  schedule: schedules[index],
                  onEdit: () async {
                    final details = await ref
                        .read(scheduleListNotifierProvider.notifier)
                        .getScheduleDetails(schedules[index].id);
                    if (context.mounted) {
                      final result = await showModalBottomSheet<bool>(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (context) => ScheduleEditModal(schedule: details),
                      );
                      if (result == true) {
                        ref.invalidate(scheduleListNotifierProvider);
                      }
                    }
                  },
                  onDelete: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmScheduleDeleteDialog(
                        scheduleName: schedules[index].name,
                        onConfirm: () async {
                          await ref
                              .read(scheduleListNotifierProvider.notifier)
                              .deleteSchedule(schedules[index].id);
                        },
                      ),
                    );

                    if (confirmed == true) {
                      ref.invalidate(scheduleListNotifierProvider);
                    }
                  },
                  onToggle: (enabled) async {
                    final schedule = schedules[index];
                    final details = await ref
                        .read(scheduleListNotifierProvider.notifier)
                        .getScheduleDetails(schedule.id);
                    await ref
                        .read(scheduleListNotifierProvider.notifier)
                        .saveSchedule(details.copyWith(isEnabled: enabled));
                  },
                ),
              ),
        loading: () => ListView.builder(
          padding: EdgeInsets.all(Spacing.md),
          itemCount: 3,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: Spacing.md),
            child: SkeletonCard(
              height: 80,
              showHeader: false,
              contentLines: 2,
              showActions: true,
            ),
          ),
        ),
        error: (error, stack) => Center(
          child: StandardErrorWidget(
            message: 'Failed to load schedules',
            type: ErrorType.network,
            showRetry: true,
            onPrimaryAction: () => ref.refresh(scheduleListNotifierProvider),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () async {
          final result = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (context) => const ScheduleEditModal(),
          );
          if (result == true) {
            ref.invalidate(scheduleListNotifierProvider);
          }
        },
        child: Icon(
          Icons.add,
          color: theme.colorScheme.surface,
        ),
      ),
    );
  }
}

class _ScheduleListCard extends StatelessWidget {
  final ScheduleListItem schedule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const _ScheduleListCard({
    required this.schedule,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = AppTheme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 20,
                            color: appTheme.scheduleIconColor,
                          ),
                          SizedBox(width: Spacing.xs),
                          Expanded(
                            child: Text(
                              schedule.name,
                              style: appTheme.cardTitleStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Spacing.unit),
                      Consumer(
                        builder: (context, ref, child) {
                          final detailsAsync = ref.watch(
                            scheduleDetailsProvider(schedule.id)
                          );
                          
                          return detailsAsync.when(
                            data: (details) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Schedule type and days/interval
                                Row(
                                  children: [
                                    Icon(
                                      details.type == ScheduleType.dayBased 
                                        ? Icons.calendar_today 
                                        : Icons.repeat,
                                      size: 16,
                                      color: appTheme.mutedTextColor,
                                    ),
                                    SizedBox(width: Spacing.xs),
                                    Expanded(
                                      child: Text(
                                        details.type == ScheduleType.dayBased
                                          ? _formatDays(details.days)
                                          : 'Every ${details.interval} day${details.interval > 1 ? 's' : ''}',
                                        style: appTheme.subtitleTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Spacing.unit),
                                // Start times
                                Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: 16,
                                      color: appTheme.mutedTextColor,
                                    ),
                                    SizedBox(width: Spacing.xs),
                                    Expanded(
                                      child: Text(
                                        _formatTimes(context, details.times),
                                        style: appTheme.subtitleTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                if (schedule.formattedNextRun != null) ...[
                                  SizedBox(height: Spacing.unit),
                                  // Next run time
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.update,
                                        size: 16,
                                        color: appTheme.mutedTextColor,
                                      ),
                                      SizedBox(width: Spacing.xs),
                                      Text(
                                        'Next run: ${schedule.formattedNextRun}',
                                        style: appTheme.subtitleTextStyle,
                                      ),
                                    ],
                                  ),
                                ],
                                if (details.isWeatherAdjusted) ...[
                                  SizedBox(height: Spacing.unit),
                                  // Weather adjust indicator
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.water_drop,
                                        size: 16,
                                        color: appTheme.weatherIconColor.withOpacity(0.7),
                                      ),
                                      SizedBox(width: Spacing.xs),
                                      Text(
                                        'Weather adjusted',
                                        style: appTheme.subtitleTextStyle.copyWith(
                                          color: appTheme.weatherIconColor.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            loading: () => const SizedBox(
                              height: 24,
                              child: Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            error: (_, __) => Text(
                              'Error loading schedule details',
                              style: appTheme.statusTextStyle.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer(
                      builder: (context, ref, _) {
                        final toggleState = ref.watch(scheduleToggleStateProvider(schedule.id));
                        
                        if (toggleState.isLoading) {
                          return const SizedBox(
                            height: 24,
                            width: 24,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        
                        if (toggleState.isError) {
                          return Switch(
                            value: schedule.isEnabled,
                            onChanged: null,
                          );
                        }
                        
                        return Switch(
                          value: schedule.isEnabled,
                          onChanged: (enabled) async {
                            try {
                              ref.read(scheduleToggleStateProvider(schedule.id).notifier).startLoading();
                              final details = await ref
                                  .read(scheduleListNotifierProvider.notifier)
                                  .getScheduleDetails(schedule.id);
                              await ref
                                  .read(scheduleListNotifierProvider.notifier)
                                  .saveSchedule(details.copyWith(isEnabled: enabled));
                              if (context.mounted) {
                                ref.read(scheduleToggleStateProvider(schedule.id).notifier).setSuccess();
                                onToggle(enabled);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ref.read(scheduleToggleStateProvider(schedule.id).notifier).setError();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to update schedule: $e',
                                      style: appTheme.statusTextStyle,
                                    ),
                                    backgroundColor: theme.colorScheme.error,
                                  ),
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(Spacing.unit),
                      child: IconButton.filled(
                        icon: Icon(
                          Icons.edit,
                          color: theme.colorScheme.surface,
                        ),
                        onPressed: onEdit,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(Spacing.unit),
                      child: IconButton.filled(
                        icon: Icon(
                          Icons.delete,
                          color: theme.colorScheme.surface,
                        ),
                        onPressed: onDelete,
                        style: IconButton.styleFrom(
                          backgroundColor: appTheme.disabledStateColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDays(List<bool> days) {
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final enabledDays = <String>[];
    
    for (var i = 0; i < days.length; i++) {
      if (days[i]) enabledDays.add(dayNames[i]);
    }
    
    if (enabledDays.isEmpty) return 'No days selected';
    if (enabledDays.length == 7) return 'Every day';
    if (enabledDays.length >= 4) {
      final disabledDays = dayNames.where((day) => !enabledDays.contains(day));
      return 'Except ${disabledDays.join(', ')}';
    }
    return enabledDays.join(', ');
  }

  String _formatTimes(BuildContext context, List<ScheduleTime> times) {
    final enabledTimes = times.where((t) => t.isEnabled).map((t) {
      final hour = int.parse(t.time.split(':')[0]);
      final minute = int.parse(t.time.split(':')[1]);
      return TimeOfDay(hour: hour, minute: minute).format(context);
    }).toList();
    
    if (enabledTimes.isEmpty) return 'No times set';
    return enabledTimes.join(', ');
  }
}

class _ScheduleTypeBadge extends StatelessWidget {
  final String type;
  final Color? color;

  const _ScheduleTypeBadge({
    required this.type,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = color ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withOpacity(0.5)),
      ),
      child: Text(
        type,
        style: theme.textTheme.bodySmall?.copyWith(color: badgeColor),
      ),
    );
  }
}

class _EmptyScheduleList extends StatelessWidget {
  const _EmptyScheduleList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule,
              size: 64,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Schedules',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Create a schedule to automatically water your zones',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 