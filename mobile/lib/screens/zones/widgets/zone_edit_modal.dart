import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../api/models/zone.dart';
import '../../../providers/zone_provider.dart';

class ZoneEditModal extends ConsumerStatefulWidget {
  final Zone zone;

  const ZoneEditModal({
    super.key,
    required this.zone,
  });

  @override
  ConsumerState<ZoneEditModal> createState() => _ZoneEditModalState();
}

class _ZoneEditModalState extends ConsumerState<ZoneEditModal> {
  late final TextEditingController _nameController;
  late bool _isEnabled;
  late bool _isPumpAssociated;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.zone.name);
    _isEnabled = widget.zone.isEnabled;
    _isPumpAssociated = widget.zone.isPumpAssociated;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final updatedZone = Zone(
      id: widget.zone.id,
      name: _nameController.text.trim(),
      isEnabled: _isEnabled,
      state: widget.zone.state,
      isPumpAssociated: _isPumpAssociated,
    );

    try {
      await ref.read(zonesNotifierProvider.notifier).updateZone(updatedZone);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update zone: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Edit Zone ${widget.zone.id}',
                  style: theme.textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Zone Name',
                helperText: 'Maximum 19 characters',
              ),
              maxLength: 19,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enabled'),
              value: _isEnabled,
              onChanged: (value) => setState(() => _isEnabled = value),
            ),
            SwitchListTile(
              title: const Text('Pump Associated'),
              value: _isPumpAssociated,
              onChanged: (value) => setState(() => _isPumpAssociated = value),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
} 