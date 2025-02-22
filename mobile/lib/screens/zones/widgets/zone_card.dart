import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../api/models/zone.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/spacing.dart';
import '../../../widgets/zone_toggle_widget.dart';
import 'zone_edit_modal.dart';

class ZoneCard extends ConsumerStatefulWidget {
  final Zone zone;
  final Future<void> Function(bool) onToggle;

  const ZoneCard({
    super.key,
    required this.zone,
    required this.onToggle,
  });

  @override
  ConsumerState<ZoneCard> createState() => _ZoneCardState();
}

class _ZoneCardState extends ConsumerState<ZoneCard> {
  bool _isLoading = false;

  Future<void> _handleToggle(bool enabled) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onToggle(enabled);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to toggle zone: ${e.toString()}',
              style: AppTheme.of(context).statusTextStyle,
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Theme.of(context).colorScheme.onError,
              onPressed: () => _handleToggle(enabled),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showEditModal(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => ZoneEditModal(zone: widget.zone),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = AppTheme.of(context);
    
    return Material(
      type: MaterialType.card,
      color: theme.colorScheme.surface,
      elevation: 2,
      borderRadius: BorderRadius.circular(Spacing.md),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: ZoneToggleWidget(
                  zoneId: widget.zone.id,
                  name: widget.zone.name,
                  isEnabled: widget.zone.isEnabled,
                  isRunning: widget.zone.state,
                  hasPumpAssociation: widget.zone.isPumpAssociated,
                  onStateChanged: _handleToggle,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Spacing.xs),
                child: IconButton.filled(
                  icon: Icon(
                    Icons.edit,
                    color: theme.colorScheme.surface,
                  ),
                  onPressed: _isLoading ? null : () => _showEditModal(context),
                ),
              ),
              SizedBox(width: Spacing.xs),
            ],
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(Spacing.md),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: appTheme.activeZoneColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 