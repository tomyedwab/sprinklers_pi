import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'quick_schedule_dialog.dart';

class QuickActionsCard extends ConsumerWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickAction(
                  context: context,
                  icon: Icons.play_circle_outline,
                  label: 'Quick Run',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const QuickScheduleDialog(),
                    );
                  },
                ),
                _buildQuickAction(
                  context: context,
                  icon: Icons.stop_circle_outlined,
                  label: 'Stop All',
                  onTap: () {
                    // TODO: Implement stop all zones
                  },
                ),
                _buildQuickAction(
                  context: context,
                  icon: Icons.schedule,
                  label: 'Next Run',
                  onTap: () {
                    // TODO: Show next scheduled run info
                  },
                ),
                _buildQuickAction(
                  context: context,
                  icon: Icons.water_drop,
                  label: 'Rain Delay',
                  onTap: () {
                    // TODO: Implement rain delay dialog
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 