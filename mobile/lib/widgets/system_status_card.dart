import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/system_state_provider.dart';

class SystemStatusCard extends ConsumerWidget {
  const SystemStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemStateAsync = ref.watch(systemStateNotifierProvider);

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
                  'System Status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                systemStateAsync.when(
                  loading: () => const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (_, __) => const Icon(Icons.error, color: Colors.red),
                  data: (state) => Switch(
                    value: state.isRunning,
                    onChanged: (value) {
                      // TODO: Implement system-wide enable/disable
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            systemStateAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  'Error: ${error.toString()}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              data: (state) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatusItem(
                    icon: Icons.grid_view,
                    label: 'Zones',
                    value: state.enabledZonesCount.toString(),
                  ),
                  _buildStatusItem(
                    icon: Icons.schedule,
                    label: 'Schedules',
                    value: state.schedulesCount.toString(),
                  ),
                  _buildStatusItem(
                    icon: Icons.access_time,
                    label: 'Status',
                    value: state.isRunning ? 'Running' : 'Stopped',
                    valueColor: state.isRunning ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
} 