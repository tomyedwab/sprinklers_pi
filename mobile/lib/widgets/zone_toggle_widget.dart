import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that displays and controls the state of a sprinkler zone.
/// Handles both manual control and status display.
class ZoneToggleWidget extends ConsumerStatefulWidget {
  /// The 0-based zone ID (0 for first zone)
  final int zoneId;
  
  /// Whether the zone is enabled in settings
  final bool isEnabled;
  
  /// Whether the zone is currently running
  final bool isRunning;
  
  /// Whether the zone has a pump association
  final bool hasPumpAssociation;

  /// The display name for the zone
  final String? name;
  
  /// Optional callback when zone state changes
  final Function(bool)? onStateChanged;

  const ZoneToggleWidget({
    super.key,
    required this.zoneId,
    required this.isEnabled,
    required this.isRunning,
    required this.hasPumpAssociation,
    this.name,
    this.onStateChanged,
  });

  @override
  ConsumerState<ZoneToggleWidget> createState() => _ZoneToggleWidgetState();
}

class _ZoneToggleWidgetState extends ConsumerState<ZoneToggleWidget> {
  /// Converts 0-based zone ID to API format (0→'za', 1→'zb', etc.)
  String get apiZoneId => 'z${String.fromCharCode('a'.codeUnitAt(0) + widget.zoneId)}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine visual state colors
    final Color stateColor = widget.isEnabled
        ? widget.isRunning
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withOpacity(0.38);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Zone status indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: stateColor,
            ),
          ),
          const SizedBox(width: 12),
          
          // Zone title and pump indicator
          Expanded(
            child: Row(
              children: [
                Text(
                  widget.name ?? 'Zone ${widget.zoneId + 1}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: stateColor,
                    fontStyle: widget.isEnabled ? null : FontStyle.italic,
                  ),
                ),
                if (widget.hasPumpAssociation) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.waves,
                    size: 16,
                    color: stateColor,
                  ),
                ],
              ],
            ),
          ),
          
          // Toggle switch
          if (widget.isEnabled)
            Switch(
              value: widget.isRunning,
              onChanged: widget.isEnabled
                  ? (bool value) {
                      widget.onStateChanged?.call(value);
                    }
                  : null,
            ),
        ],
      ),
    );
  }
} 