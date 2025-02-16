import 'package:flutter/material.dart';
import '../../../api/models/zone.dart';
import '../../../widgets/zone_toggle_widget.dart';
import 'zone_edit_modal.dart';

class ZoneCard extends StatelessWidget {
  final Zone zone;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onEdit;

  const ZoneCard({
    super.key,
    required this.zone,
    required this.onToggle,
    this.onEdit,
  });

  Future<void> _showEditModal(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ZoneEditModal(zone: zone),
    );

    if (result == true) {
      onEdit?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      type: MaterialType.card,
      color: theme.colorScheme.surface,
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          Expanded(
            child: ZoneToggleWidget(
              zoneId: zone.id,
              name: zone.name,
              isEnabled: zone.isEnabled,
              isRunning: zone.state,
              hasPumpAssociation: zone.isPumpAssociated,
              onStateChanged: onToggle,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: theme.colorScheme.secondary,
            ),
            onPressed: () => _showEditModal(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
} 