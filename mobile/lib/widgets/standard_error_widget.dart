import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/spacing.dart';

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

  /// Success type
  success,
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
      case ErrorType.success:
        return Icons.check_circle;
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
      case ErrorType.success:
        return 'OK';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = AppTheme.of(context);

    final colors = switch (type) {
      ErrorType.success => (
        container: theme.colorScheme.primaryContainer,
        foreground: theme.colorScheme.primary,
        border: theme.colorScheme.primary,
      ),
      _ => (
        container: theme.colorScheme.errorContainer,
        foreground: theme.colorScheme.error,
        border: theme.colorScheme.errorContainer,
      ),
    };

    return Container(
      padding: EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colors.container.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Spacing.xs),
        border: Border.all(
          color: colors.border,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _errorIcon,
            size: Spacing.xl,
            color: colors.foreground,
          ),
          SizedBox(height: Spacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: appTheme.statusTextStyle.copyWith(
              color: colors.foreground,
            ),
          ),
          if (showRetry || primaryActionText != null || secondaryActionText != null)
            SizedBox(height: Spacing.md),
          if (showRetry || primaryActionText != null || secondaryActionText != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (secondaryActionText != null)
                  TextButton(
                    onPressed: onSecondaryAction,
                    child: Text(
                      secondaryActionText!,
                      style: appTheme.subtitleTextStyle,
                    ),
                  ),
                if (secondaryActionText != null && (showRetry || primaryActionText != null))
                  SizedBox(width: Spacing.xs),
                if (showRetry || primaryActionText != null)
                  FilledButton.icon(
                    onPressed: onPrimaryAction,
                    icon: Icon(
                      showRetry ? Icons.refresh : null,
                      size: Spacing.md,
                    ),
                    label: Text(
                      primaryActionText ?? _defaultPrimaryAction,
                      style: appTheme.valueTextStyle.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
} 