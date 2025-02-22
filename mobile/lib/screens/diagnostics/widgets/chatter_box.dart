import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/zone_provider.dart';
import '../../../api/api_client.dart';
import '../../../widgets/standard_error_widget.dart';
import '../../../widgets/loading_states.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/spacing.dart';

class ChatterBox extends ConsumerStatefulWidget {
  const ChatterBox({super.key});

  @override
  ConsumerState<ChatterBox> createState() => _ChatterBoxState();
}

class _ChatterBoxState extends ConsumerState<ChatterBox> {
  String? _selectedZone;
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    final zonesAsync = ref.watch(zonesNotifierProvider);
    final appTheme = AppTheme.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: Spacing.screenPaddingAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: Spacing.cardPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chatter Box',
                    style: appTheme.cardTitleStyle,
                  ),
                  SizedBox(height: Spacing.xs),
                  Text(
                    'Send a test message to a zone to verify communication.',
                    style: appTheme.subtitleTextStyle,
                  ),
                  SizedBox(height: Spacing.md),
                  zonesAsync.when(
                    loading: () => const SkeletonCard(height: 56),
                    error: (error, stack) => StandardErrorWidget(
                      message: 'Failed to load zones',
                      type: ErrorType.network,
                      showRetry: true,
                      onPrimaryAction: () => ref.refresh(zonesNotifierProvider),
                    ),
                    data: (zones) {
                      final enabledZones = zones.where((z) => z.isEnabled).toList();
                      if (enabledZones.isEmpty) {
                        return const StandardErrorWidget(
                          message: 'No enabled zones found',
                          type: ErrorType.generic,
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Select Zone',
                              labelStyle: appTheme.subtitleTextStyle,
                              border: const OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: Spacing.md,
                                vertical: Spacing.sm,
                              ),
                            ),
                            value: _selectedZone,
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(
                                  'Select a zone',
                                  style: appTheme.subtitleTextStyle,
                                ),
                              ),
                              ...enabledZones.map(
                                (zone) => DropdownMenuItem(
                                  value: zone.id.toString(),
                                  child: Text(
                                    '${zone.id + 1}: ${zone.name}',
                                    style: appTheme.valueTextStyle,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: _isSending ? null : (value) {
                              setState(() {
                                _selectedZone = value;
                              });
                            },
                          ),
                          SizedBox(height: Spacing.md),
                          FilledButton.icon(
                            onPressed: (_selectedZone == null || _isSending)
                                ? null
                                : () async {
                                    setState(() => _isSending = true);
                                    try {
                                      final apiClient = ref.read(apiClientProvider);
                                      await apiClient.sendChatterMessage(
                                        zoneId: int.parse(_selectedZone!),
                                        state: true,
                                      );
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Message sent successfully',
                                              style: appTheme.valueTextStyle.copyWith(
                                                color: theme.colorScheme.onPrimary,
                                              ),
                                            ),
                                            backgroundColor: appTheme.enabledStateColor,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: StandardErrorWidget(
                                              message: 'Failed to send message',
                                              type: ErrorType.network,
                                              showRetry: true,
                                              onPrimaryAction: () async {
                                                final apiClient = ref.read(apiClientProvider);
                                                await apiClient.sendChatterMessage(
                                                  zoneId: int.parse(_selectedZone!),
                                                  state: true,
                                                );
                                              },
                                            ),
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            duration: const Duration(seconds: 5),
                                          ),
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isSending = false);
                                      }
                                    }
                                  },
                            icon: _isSending
                                ? SizedBox(
                                    width: Spacing.md,
                                    height: Spacing.md,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  )
                                : Icon(
                                    Icons.send,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                            label: Text(
                              _isSending ? 'Sending...' : 'Send Message',
                              style: appTheme.valueTextStyle.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
                    'Usage',
                    style: appTheme.cardTitleStyle,
                  ),
                  SizedBox(height: Spacing.md),
                  Text(
                    '1. Select a zone to test\n'
                    '2. Click "Send Message" to send a test message\n'
                    '3. Check system response in logs',
                    style: appTheme.valueTextStyle.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 