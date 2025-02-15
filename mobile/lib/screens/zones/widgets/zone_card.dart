import 'package:flutter/material.dart';
import '../../../api/models/zone.dart';
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        zone.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontStyle: zone.isEnabled ? null : FontStyle.italic,
                        ),
                      ),
                      if (!zone.isEnabled)
                        Text(
                          'Disabled',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                    ],
                  ),
                ),
                if (zone.isEnabled) ...[
                  Switch(
                    value: zone.state,
                    onChanged: onToggle,
                  ),
                ],
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditModal(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.water_drop,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  zone.isPumpAssociated ? 'Pump Associated' : 'No Pump',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            if (zone.state) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Currently Running',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 