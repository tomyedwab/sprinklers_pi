import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/schedule_provider.dart';
import '../models/schedule.dart';

class UpcomingSchedulesCard extends ConsumerWidget {
  const UpcomingSchedulesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(scheduleListNotifierProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming Schedules',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to schedules screen
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            schedulesAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error loading schedules: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              data: (schedules) {
                if (schedules.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No upcoming schedules',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                // Filter enabled schedules with next run time
                final upcomingSchedules = schedules
                    .where((s) => s.isEnabled && s.nextRun != null)
                    .toList();

                if (upcomingSchedules.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No upcoming schedules',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                final displaySchedules = upcomingSchedules.take(3).toList();

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displaySchedules.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final schedule = displaySchedules[index];
                    return _buildScheduleItem(schedule);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(Schedule schedule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.schedule,
            size: 24,
            color: Colors.blue,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              schedule.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (schedule.nextRun != null)
            Text(
              schedule.nextRun!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
} 