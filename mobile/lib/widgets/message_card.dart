import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/spacing.dart';

/// A card widget that displays a message with an icon and gradient background
class MessageCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color primaryColor;
  final Color? textColor;
  final double iconSize;
  final String? docLink;
  final VoidCallback? onDocLinkTap;

  const MessageCard({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.primaryColor,
    this.textColor,
    this.iconSize = Spacing.xxl,
    this.docLink,
    this.onDocLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? Theme.of(context).colorScheme.surface;
    final appTheme = AppTheme.of(context);

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Spacing.md),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor,
              primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Padding(
          padding: Spacing.cardPaddingAll,
          child: Column(
            children: [
              Icon(
                icon,
                color: effectiveTextColor,
                size: iconSize,
              ),
              SizedBox(height: Spacing.md),
              Text(
                title,
                style: appTheme.cardTitleStyle.copyWith(
                  color: effectiveTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Spacing.xs),
              Text(
                message,
                style: appTheme.subtitleTextStyle.copyWith(
                  color: effectiveTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              if (docLink != null) ...[
                SizedBox(height: Spacing.md),
                TextButton.icon(
                  onPressed: onDocLinkTap,
                  icon: Icon(Icons.help_outline, color: effectiveTextColor),
                  label: Text(
                    'View Documentation',
                    style: appTheme.subtitleTextStyle.copyWith(
                      color: effectiveTextColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 