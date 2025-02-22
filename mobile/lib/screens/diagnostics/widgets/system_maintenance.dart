import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/system_state_provider.dart';
import '../../../api/api_client.dart';
import '../../../widgets/standard_error_widget.dart';
import '../../../widgets/loading_states.dart';
import '../../../widgets/confirmation_dialogs.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/spacing.dart';

class SystemMaintenance extends ConsumerWidget {
  const SystemMaintenance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemState = ref.watch(systemStateNotifierProvider);
    final appTheme = AppTheme.of(context);

    return RefreshIndicator(
      onRefresh: () => ref.read(systemStateNotifierProvider.notifier).refresh(),
      child: ListView(
        padding: Spacing.screenPaddingAll,
        children: [
          Card(
            child: Padding(
              padding: Spacing.cardPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Information',
                    style: appTheme.cardTitleStyle,
                  ),
                  SizedBox(height: Spacing.md),
                  systemState.when(
                    data: (state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(context, 'Version', state.version),
                        _buildInfoRow(context, 'Status', state.isRunning ? 'Running' : 'Stopped'),
                        _buildInfoRow(context, 'Enabled Zones', state.enabledZonesCount.toString()),
                        _buildInfoRow(context, 'Schedules', state.schedulesCount.toString()),
                        _buildInfoRow(context, 'Events', state.eventsCount.toString()),
                        if (state.activeZoneName != null) ...[
                          _buildInfoRow(context, 'Active Zone', state.activeZoneName!),
                          if (state.remainingTime != null)
                            _buildInfoRow(
                              context,
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
          SizedBox(height: Spacing.md),
          Card(
            child: Padding(
              padding: Spacing.cardPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Maintenance',
                    style: appTheme.cardTitleStyle,
                  ),
                  SizedBox(height: Spacing.md),
                  ListTile(
                    leading: Icon(Icons.refresh, color: appTheme.scheduleIconColor),
                    title: Text('Reset System', style: appTheme.valueTextStyle),
                    subtitle: Text(
                      'Restart all system services',
                      style: appTheme.subtitleTextStyle,
                    ),
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
                    leading: Icon(Icons.restore, color: appTheme.disabledStateColor),
                    title: Text('Factory Reset', style: appTheme.valueTextStyle),
                    subtitle: Text(
                      'Reset all settings to factory defaults',
                      style: appTheme.subtitleTextStyle,
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

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final appTheme = AppTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Spacing.unit),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: appTheme.valueTextStyle,
          ),
          Text(
            value,
            style: appTheme.subtitleTextStyle,
          ),
        ],
      ),
    );
  }
} 