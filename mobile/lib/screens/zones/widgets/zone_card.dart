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
    return Card(
      child: ZoneToggleWidget(
        zoneId: zone.id,
        name: zone.name,
        isEnabled: zone.isEnabled,
        isRunning: zone.state,
        hasPumpAssociation: zone.isPumpAssociated,
        onStateChanged: onToggle,
        onLongPress: () => _showEditModal(context),
      ),
    );
  }
} 