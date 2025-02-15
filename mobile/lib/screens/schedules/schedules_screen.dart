import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/schedule_zone_provider.dart';
import '../../models/schedule.dart';

class SchedulesScreen extends ConsumerWidget {
  const SchedulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(scheduleListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedules'),
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
                  onEdit: () {
                    // TODO: Implement edit
                  },
                  onDelete: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Schedule'),
                        content: Text('Are you sure you want to delete "${schedules[index].name}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await ref
                          .read(scheduleListNotifierProvider.notifier)
                          .deleteSchedule(schedules[index].id);
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Failed to load schedules'),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(scheduleListNotifierProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add schedule
        },
        child: const Icon(Icons.add),
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
      child: ListTile(
        title: Text(schedule.name, style: theme.textTheme.titleMedium),
        subtitle: schedule.formattedNextRun != null
            ? Text(
                'Next run: ${schedule.formattedNextRun}',
                style: theme.textTheme.bodySmall,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: schedule.isEnabled,
              onChanged: onToggle,
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
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
    final badgeColor = color ?? (type == 'Daily' ? Colors.blue : Colors.purple);

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
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 