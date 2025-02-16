import 'package:flutter/material.dart';

/// Type of error to display
enum ErrorType {
  /// Network-related errors
  network,

  /// Validation errors
  validation,

  /// Permission errors
  permission,

  /// Generic errors
  generic,
}

/// A standardized widget for displaying errors
class StandardErrorWidget extends StatelessWidget {
  /// The error message to display
  final String message;

  /// Type of error
  final ErrorType type;

  /// Primary action button text
  final String? primaryActionText;

  /// Secondary action button text
  final String? secondaryActionText;

  /// Callback for primary action
  final VoidCallback? onPrimaryAction;

  /// Callback for secondary action
  final VoidCallback? onSecondaryAction;

  /// Whether to show a retry button
  final bool showRetry;

  const StandardErrorWidget({
    super.key,
    required this.message,
    this.type = ErrorType.generic,
    this.primaryActionText,
    this.secondaryActionText,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.showRetry = false,
  });

  IconData get _errorIcon {
    switch (type) {
      case ErrorType.network:
        return Icons.cloud_off;
      case ErrorType.validation:
        return Icons.error_outline;
      case ErrorType.permission:
        return Icons.lock;
      case ErrorType.generic:
        return Icons.warning;
    }
  }

  String get _defaultPrimaryAction {
    switch (type) {
      case ErrorType.network:
        return 'Try Again';
      case ErrorType.validation:
        return 'Fix';
      case ErrorType.permission:
        return 'Request Access';
      case ErrorType.generic:
        return 'OK';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.errorContainer,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _errorIcon,
            size: 32,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          if (showRetry || primaryActionText != null || secondaryActionText != null)
            const SizedBox(height: 16),
          if (showRetry || primaryActionText != null || secondaryActionText != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (secondaryActionText != null)
                  TextButton(
                    onPressed: onSecondaryAction,
                    child: Text(secondaryActionText!),
                  ),
                if (secondaryActionText != null && (showRetry || primaryActionText != null))
                  const SizedBox(width: 8),
                if (showRetry || primaryActionText != null)
                  FilledButton.icon(
                    onPressed: onPrimaryAction,
                    icon: Icon(showRetry ? Icons.refresh : null),
                    label: Text(primaryActionText ?? _defaultPrimaryAction),
                  ),
              ],
            ),
        ],
      ),
    );
  }
} 