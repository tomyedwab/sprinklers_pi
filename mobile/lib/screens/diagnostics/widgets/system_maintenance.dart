import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/system_state_provider.dart';
import '../../../api/api_client.dart';

class SystemMaintenance extends ConsumerWidget {
  const SystemMaintenance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemState = ref.watch(systemStateNotifierProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(systemStateNotifierProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  systemState.when(
                    data: (state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Version', state.version),
                        _buildInfoRow('Status', state.isRunning ? 'Running' : 'Stopped'),
                        _buildInfoRow('Enabled Zones', state.enabledZonesCount.toString()),
                        _buildInfoRow('Schedules', state.schedulesCount.toString()),
                        _buildInfoRow('Events', state.eventsCount.toString()),
                        if (state.activeZoneName != null) ...[
                          _buildInfoRow('Active Zone', state.activeZoneName!),
                          if (state.remainingTime != null)
                            _buildInfoRow(
                              'Remaining Time',
                              state.remainingTime!.inSeconds == 99999
                                  ? 'Manual Mode'
                                  : '${state.remainingTime!.inMinutes}m ${state.remainingTime!.inSeconds % 60}s',
                            ),
                        ],
                      ],
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Text(
                      'Error: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Maintenance',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.refresh),
                    title: const Text('Reset System'),
                    subtitle: const Text('Restart all system services'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Reset System'),
                          content: const Text(
                            'Are you sure you want to reset the system? '
                            'This will restart all services while maintaining your settings.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () async {
                                try {
                                  Navigator.of(context).pop();
                                  final apiClient = ref.read(apiClientProvider);
                                  await apiClient.resetSystem();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('System reset initiated'),
                                      ),
                                    );
                                  }
                                  // Refresh system state after reset
                                  ref.read(systemStateNotifierProvider.notifier).refresh();
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to reset system: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.restore),
                    title: const Text('Factory Reset'),
                    subtitle: const Text(
                      'Reset all settings to factory defaults',
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Factory Reset'),
                          content: const Text(
                            'Are you sure you want to reset to factory defaults?\n\n'
                            'This will erase ALL settings including:\n'
                            '• Zone configurations\n'
                            '• Schedules\n'
                            '• Network settings\n'
                            '• Weather provider settings\n\n'
                            'This action cannot be undone!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () async {
                                try {
                                  Navigator.of(context).pop();
                                  final apiClient = ref.read(apiClientProvider);
                                  await apiClient.factoryReset();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Factory reset initiated'),
                                      ),
                                    );
                                  }
                                  // Refresh system state after reset
                                  ref.read(systemStateNotifierProvider.notifier).refresh();
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to factory reset: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
} 