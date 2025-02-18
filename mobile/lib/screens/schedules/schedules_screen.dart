import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/schedule_zone_provider.dart';
import '../../models/schedule.dart';
import '../../widgets/loading_states.dart';
import '../../widgets/confirmation_dialogs.dart';
import '../../widgets/standard_error_widget.dart';
import '../../widgets/zone_toggle_widget.dart';
import 'widgets/schedule_edit_modal.dart';

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
                padding: const EdgeInsets.all(16.0),
                itemCount: schedules.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
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
          padding: const EdgeInsets.all(16.0),
          itemCount: 3,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              schedule.name,
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
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
                                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        details.type == ScheduleType.dayBased
                                          ? _formatDays(details.days)
                                          : 'Every ${details.interval} day${details.interval > 1 ? 's' : ''}',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                // Start times
                                Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: 16,
                                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _formatTimes(context, details.times),
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (schedule.formattedNextRun != null) ...[
                                  const SizedBox(height: 4),
                                  // Next run time
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.update,
                                        size: 16,
                                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Next run: ${schedule.formattedNextRun}',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (details.isWeatherAdjusted) ...[
                                  const SizedBox(height: 4),
                                  // Weather adjust indicator
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.water_drop,
                                        size: 16,
                                        color: theme.colorScheme.primary.withOpacity(0.7),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Weather adjusted',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.primary.withOpacity(0.7),
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
                              style: theme.textTheme.bodyMedium?.copyWith(
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
                    Switch(
                      value: schedule.isEnabled,
                      onChanged: onToggle,
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: theme.colorScheme.secondary),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: theme.colorScheme.error),
                      onPressed: onDelete,
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