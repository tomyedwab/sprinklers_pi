import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/zone_provider.dart';
import '../../../api/api_client.dart';

class ChatterBox extends ConsumerStatefulWidget {
  const ChatterBox({super.key});

  @override
  ConsumerState<ChatterBox> createState() => _ChatterBoxState();
}

class _ChatterBoxState extends ConsumerState<ChatterBox> {
  String? _selectedZone;

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
                    'Test system communication and monitor responses.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  zonesAsync.when(
                    data: (zones) => Column(
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
                            ...zones.where((z) => z.isEnabled).map(
                              (zone) => DropdownMenuItem(
                                value: zone.id.toString(),
                                child: Text('${zone.id + 1}: ${zone.name}'),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedZone = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _selectedZone == null
                              ? null
                              : () async {
                                  try {
                                    final apiClient = ref.read(apiClientProvider);
                                    await apiClient.sendChatterMessage(
                                      zoneId: int.parse(_selectedZone!),
                                      state: true, // State doesn't matter
                                    );
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Message sent successfully'),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to send message: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                          icon: const Icon(Icons.send),
                          label: const Text('Test Communication'),
                        ),
                      ],
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Text(
                      'Error loading zones: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
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
                    '2. Click "Test Communication" to send a test message\n'
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