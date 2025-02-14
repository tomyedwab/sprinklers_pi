import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpcomingSchedulesCard extends ConsumerWidget {
  const UpcomingSchedulesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Connect to actual schedule provider
    final upcomingSchedules = [
      _ScheduleItem(
        zoneName: 'Front Lawn',
        time: DateTime.now().add(const Duration(hours: 2)),
        duration: const Duration(minutes: 20),
      ),
      _ScheduleItem(
        zoneName: 'Back Garden',
        time: DateTime.now().add(const Duration(hours: 4)),
        duration: const Duration(minutes: 15),
      ),
    ];

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
            if (upcomingSchedules.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No upcoming schedules',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: upcomingSchedules.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final schedule = upcomingSchedules[index];
                  return _buildScheduleItem(schedule);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(_ScheduleItem schedule) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.zoneName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Duration: ${schedule.duration.inMinutes} minutes',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatTime(schedule.time),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final scheduleDate = DateTime(time.year, time.month, time.day);

    if (scheduleDate == today) {
      return 'Today ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (scheduleDate == tomorrow) {
      return 'Tomorrow ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.month}/${time.day} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}

class _ScheduleItem {
  final String zoneName;
  final DateTime time;
  final Duration duration;

  const _ScheduleItem({
    required this.zoneName,
    required this.time,
    required this.duration,
  });
} 