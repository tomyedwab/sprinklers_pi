import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/zone_provider.dart';
import '../../../api/api_client.dart';
import '../../../widgets/standard_error_widget.dart';
import '../../../widgets/loading_states.dart';

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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chatter Box',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Send a test message to a zone to verify communication.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                            decoration: const InputDecoration(
                              labelText: 'Select Zone',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedZone,
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('Select a zone'),
                              ),
                              ...enabledZones.map(
                                (zone) => DropdownMenuItem(
                                  value: zone.id.toString(),
                                  child: Text('${zone.id + 1}: ${zone.name}'),
                                ),
                              ),
                            ],
                            onChanged: _isSending ? null : (value) {
                              setState(() {
                                _selectedZone = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
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
                                          const SnackBar(
                                            content: Text('Message sent successfully'),
                                            backgroundColor: Colors.green,
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
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.send),
                            label: Text(_isSending ? 'Sending...' : 'Send Message'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usage',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '1. Select a zone to test\n'
                    '2. Click "Send Message" to send a test message\n'
                    '3. Check system response in logs',
                    style: TextStyle(height: 1.5),
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