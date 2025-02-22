import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../api/models/zone.dart';
import '../../../providers/zone_provider.dart';
import '../../../widgets/standard_error_widget.dart';
import '../../../widgets/confirmation_dialogs.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/spacing.dart';

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
    final appTheme = AppTheme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: mediaQuery.size.width > 600 ? 600 : mediaQuery.size.width * 0.9,
          maxHeight: mediaQuery.size.height * 0.9,
        ),
        child: Padding(
          padding: EdgeInsets.all(Spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    'Edit Zone ${widget.zone.id}',
                    style: appTheme.cardTitleStyle,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: appTheme.mutedTextColor,
                    ),
                    onPressed: _confirmClose,
                  ),
                ],
              ),
              SizedBox(height: Spacing.lg),
              TextField(
                controller: _nameController,
                style: appTheme.valueTextStyle,
                decoration: InputDecoration(
                  labelText: 'Zone Name',
                  helperText: 'Maximum 19 characters',
                  helperStyle: appTheme.subtitleTextStyle,
                  labelStyle: appTheme.subtitleTextStyle,
                ),
                maxLength: 19,
              ),
              SizedBox(height: Spacing.md),
              SwitchListTile(
                title: Text(
                  'Enabled',
                  style: appTheme.valueTextStyle,
                ),
                value: _isEnabled,
                onChanged: (value) {
                  setState(() => _isEnabled = value);
                  _checkForChanges();
                },
              ),
              SwitchListTile(
                title: Text(
                  'Pump Associated',
                  style: appTheme.valueTextStyle,
                ),
                subtitle: Text(
                  'When enabled, the pump will automatically turn on when this zone is active. Use this for zones that require additional water pressure.',
                  style: appTheme.subtitleTextStyle,
                ),
                value: _isPumpAssociated,
                onChanged: (value) {
                  setState(() => _isPumpAssociated = value);
                  _checkForChanges();
                },
              ),
              SizedBox(height: Spacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _confirmClose,
                    child: Text(
                      'Cancel',
                      style: appTheme.valueTextStyle,
                    ),
                  ),
                  SizedBox(width: Spacing.xs),
                  FilledButton(
                    onPressed: _hasChanges ? _saveChanges : null,
                    child: Text(
                      'Save',
                      style: appTheme.valueTextStyle.copyWith(
                        color: theme.colorScheme.surface,
                      ),
                    ),
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