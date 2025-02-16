import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/system_state_provider.dart';
import '../../../api/api_client.dart';
import '../../../widgets/standard_error_widget.dart';
import '../../../widgets/loading_states.dart';
import '../../../widgets/confirmation_dialogs.dart';

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
                    loading: () => const SkeletonCard(
                      height: 200,
                      showHeader: false,
                      contentLines: 6,
                      showActions: false,
                    ),
                    error: (error, _) => StandardErrorWidget(
                      message: 'Failed to load system information',
                      type: ErrorType.network,
                      showRetry: true,
                      onPrimaryAction: () => ref.refresh(systemStateNotifierProvider),
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
                        builder: (context) => ConfirmActionDialog(
                          title: 'Reset System',
                          message: 'Are you sure you want to reset the system? '
                            'This will restart all services while maintaining your settings.',
                          confirmText: 'Reset',
                          icon: Icons.refresh,
                          onConfirm: () async {
                            try {
                              final apiClient = ref.read(apiClientProvider);
                              await apiClient.resetSystem();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: StandardErrorWidget(
                                      message: 'System reset initiated',
                                      type: ErrorType.generic,
                                      primaryActionText: 'Refresh',
                                      onPrimaryAction: () => ref.refresh(systemStateNotifierProvider),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    duration: const Duration(seconds: 5),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: StandardErrorWidget(
                                      message: 'Failed to reset system',
                                      type: ErrorType.network,
                                      showRetry: true,
                                      onPrimaryAction: () async {
                                        final apiClient = ref.read(apiClientProvider);
                                        await apiClient.resetSystem();
                                        ref.refresh(systemStateNotifierProvider);
                                      },
                                    ),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    duration: const Duration(seconds: 5),
                                  ),
                                );
                              }
                            }
                          },
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
                        builder: (context) => ConfirmActionDialog(
                          title: 'Factory Reset',
                          message: 'Are you sure you want to reset to factory defaults?\n\n'
                            'This will erase ALL settings including:\n'
                            '• Zone configurations\n'
                            '• Schedules\n'
                            '• Network settings\n'
                            '• Weather provider settings\n\n'
                            'This action cannot be undone!',
                          confirmText: 'Reset',
                          icon: Icons.restore,
                          isDestructive: true,
                          onConfirm: () async {
                            try {
                              final apiClient = ref.read(apiClientProvider);
                              await apiClient.factoryReset();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: StandardErrorWidget(
                                      message: 'Factory reset initiated',
                                      type: ErrorType.generic,
                                      primaryActionText: 'Refresh',
                                      onPrimaryAction: () => ref.refresh(systemStateNotifierProvider),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    duration: const Duration(seconds: 5),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: StandardErrorWidget(
                                      message: 'Failed to factory reset',
                                      type: ErrorType.network,
                                      showRetry: true,
                                      onPrimaryAction: () async {
                                        final apiClient = ref.read(apiClientProvider);
                                        await apiClient.factoryReset();
                                        ref.refresh(systemStateNotifierProvider);
                                      },
                                    ),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    duration: const Duration(seconds: 5),
                                  ),
                                );
                              }
                            }
                          },
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