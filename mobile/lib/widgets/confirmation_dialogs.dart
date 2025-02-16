import 'package:flutter/material.dart';

/// Base confirmation dialog component
class ConfirmActionDialog extends StatelessWidget {
  /// Title of the dialog
  final String title;

  /// Message to display
  final String message;

  /// Text for the confirm button
  final String confirmText;

  /// Text for the cancel button
  final String cancelText;

  /// Icon to display (optional)
  final IconData? icon;

  /// Color for the icon and confirm button
  final Color? accentColor;

  /// Whether the action is destructive
  final bool isDestructive;

  /// Callback when confirm is pressed
  final VoidCallback? onConfirm;

  const ConfirmActionDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.icon,
    this.accentColor,
    this.isDestructive = false,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveAccentColor = accentColor ??
        (isDestructive ? theme.colorScheme.error : theme.colorScheme.primary);

    return AlertDialog(
      icon: icon != null
          ? Icon(
              icon,
              color: effectiveAccentColor,
              size: 32,
            )
          : null,
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        FilledButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop(true);
          },
          style: FilledButton.styleFrom(
            backgroundColor: effectiveAccentColor,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

/// Dialog to confirm stopping a zone
class ConfirmZoneStopDialog extends StatelessWidget {
  /// Name of the zone to stop
  final String zoneName;

  /// Callback when stop is confirmed
  final VoidCallback? onConfirm;

  const ConfirmZoneStopDialog({
    super.key,
    required this.zoneName,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmActionDialog(
      title: 'Stop Zone',
      message: 'Are you sure you want to stop watering $zoneName?',
      confirmText: 'Stop',
      icon: Icons.stop_circle,
      isDestructive: true,
      onConfirm: onConfirm,
    );
  }
}

/// Dialog to confirm deleting a schedule
class ConfirmScheduleDeleteDialog extends StatelessWidget {
  /// Name of the schedule to delete
  final String scheduleName;

  /// Callback when delete is confirmed
  final VoidCallback? onConfirm;

  const ConfirmScheduleDeleteDialog({
    super.key,
    required this.scheduleName,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmActionDialog(
      title: 'Delete Schedule',
      message: 'Are you sure you want to delete "$scheduleName"? This action cannot be undone.',
      confirmText: 'Delete',
      icon: Icons.delete_forever,
      isDestructive: true,
      onConfirm: onConfirm,
    );
  }
}

/// Dialog to confirm changing weather provider
class ConfirmWeatherProviderChangeDialog extends StatelessWidget {
  /// Name of the new provider
  final String newProviderName;

  /// Whether current schedules use weather adjustment
  final bool hasWeatherAdjustedSchedules;

  /// Callback when change is confirmed
  final VoidCallback? onConfirm;

  const ConfirmWeatherProviderChangeDialog({
    super.key,
    required this.newProviderName,
    this.hasWeatherAdjustedSchedules = false,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final message = hasWeatherAdjustedSchedules
        ? 'Changing to $newProviderName will affect schedules that use weather adjustment. Continue?'
        : 'Are you sure you want to change the weather provider to $newProviderName?';

    return ConfirmActionDialog(
      title: 'Change Weather Provider',
      message: message,
      confirmText: 'Change',
      icon: Icons.cloud_sync,
      onConfirm: onConfirm,
    );
  }
} 