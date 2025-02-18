import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../api/models/zone.dart';
import '../../../providers/zone_provider.dart';
import '../../../widgets/standard_error_widget.dart';
import '../../../widgets/confirmation_dialogs.dart';

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
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.zone.name);
    _isEnabled = widget.zone.isEnabled;
    _isPumpAssociated = widget.zone.isPumpAssociated;

    _nameController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final hasChanges = _nameController.text != widget.zone.name ||
        _isEnabled != widget.zone.isEnabled ||
        _isPumpAssociated != widget.zone.isPumpAssociated;
    
    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  Future<void> _confirmClose() async {
    if (!_hasChanges) {
      Navigator.of(context).pop();
      return;
    }

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmActionDialog(
        title: 'Discard Changes',
        message: 'You have unsaved changes. Are you sure you want to discard them?',
        confirmText: 'Discard',
        isDestructive: true,
      ),
    );

    if (shouldDiscard == true && mounted) {
      Navigator.of(context).pop();
    }
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
            content: StandardErrorWidget(
              message: 'Failed to update zone: $e',
              type: ErrorType.network,
              showRetry: true,
              onPrimaryAction: _saveChanges,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: mediaQuery.size.width > 600 ? 600 : mediaQuery.size.width * 0.9,
          maxHeight: mediaQuery.size.height * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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
                    onPressed: _confirmClose,
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
                onChanged: (value) {
                  setState(() => _isEnabled = value);
                  _checkForChanges();
                },
              ),
              SwitchListTile(
                title: const Text('Pump Associated'),
                subtitle: const Text(
                  'When enabled, the pump will automatically turn on when this zone is active. Use this for zones that require additional water pressure.',
                ),
                value: _isPumpAssociated,
                onChanged: (value) {
                  setState(() => _isPumpAssociated = value);
                  _checkForChanges();
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _confirmClose,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _hasChanges ? _saveChanges : null,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 