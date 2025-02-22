import 'package:flutter/material.dart';

/// Custom theme extension for Sprinklers Pi app
@immutable
class AppTheme extends ThemeExtension<AppTheme> {
  final Color activeZoneColor;
  final Color inactiveZoneColor;
  final Color weatherIconColor;
  final Color scheduleIconColor;
  final Color enabledStateColor;
  final Color disabledStateColor;
  final Color mutedTextColor;
  final TextStyle cardTitleStyle;
  final TextStyle valueTextStyle;
  final TextStyle subtitleTextStyle;
  final TextStyle statusTextStyle;

  const AppTheme({
    required this.activeZoneColor,
    required this.inactiveZoneColor,
    required this.weatherIconColor,
    required this.scheduleIconColor,
    required this.enabledStateColor,
    required this.disabledStateColor,
    required this.mutedTextColor,
    required this.cardTitleStyle,
    required this.valueTextStyle,
    required this.subtitleTextStyle,
    required this.statusTextStyle,
  });

  @override
  AppTheme copyWith({
    Color? activeZoneColor,
    Color? inactiveZoneColor,
    Color? weatherIconColor,
    Color? scheduleIconColor,
    Color? enabledStateColor,
    Color? disabledStateColor,
    Color? mutedTextColor,
    TextStyle? cardTitleStyle,
    TextStyle? valueTextStyle,
    TextStyle? subtitleTextStyle,
    TextStyle? statusTextStyle,
  }) {
    return AppTheme(
      activeZoneColor: activeZoneColor ?? this.activeZoneColor,
      inactiveZoneColor: inactiveZoneColor ?? this.inactiveZoneColor,
      weatherIconColor: weatherIconColor ?? this.weatherIconColor,
      scheduleIconColor: scheduleIconColor ?? this.scheduleIconColor,
      enabledStateColor: enabledStateColor ?? this.enabledStateColor,
      disabledStateColor: disabledStateColor ?? this.disabledStateColor,
      mutedTextColor: mutedTextColor ?? this.mutedTextColor,
      cardTitleStyle: cardTitleStyle ?? this.cardTitleStyle,
      valueTextStyle: valueTextStyle ?? this.valueTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
      statusTextStyle: statusTextStyle ?? this.statusTextStyle,
    );
  }

  @override
  AppTheme lerp(ThemeExtension<AppTheme>? other, double t) {
    if (other is! AppTheme) {
      return this;
    }
    return AppTheme(
      activeZoneColor: Color.lerp(activeZoneColor, other.activeZoneColor, t)!,
      inactiveZoneColor: Color.lerp(inactiveZoneColor, other.inactiveZoneColor, t)!,
      weatherIconColor: Color.lerp(weatherIconColor, other.weatherIconColor, t)!,
      scheduleIconColor: Color.lerp(scheduleIconColor, other.scheduleIconColor, t)!,
      enabledStateColor: Color.lerp(enabledStateColor, other.enabledStateColor, t)!,
      disabledStateColor: Color.lerp(disabledStateColor, other.disabledStateColor, t)!,
      mutedTextColor: Color.lerp(mutedTextColor, other.mutedTextColor, t)!,
      cardTitleStyle: TextStyle.lerp(cardTitleStyle, other.cardTitleStyle, t)!,
      valueTextStyle: TextStyle.lerp(valueTextStyle, other.valueTextStyle, t)!,
      subtitleTextStyle: TextStyle.lerp(subtitleTextStyle, other.subtitleTextStyle, t)!,
      statusTextStyle: TextStyle.lerp(statusTextStyle, other.statusTextStyle, t)!,
    );
  }

  // Helper method to get the theme from BuildContext
  static AppTheme of(BuildContext context) {
    return Theme.of(context).extension<AppTheme>()!;
  }

  // Light theme
  static AppTheme light(ThemeData theme) {
    return AppTheme(
      activeZoneColor: Colors.blue,
      inactiveZoneColor: Colors.grey,
      weatherIconColor: theme.colorScheme.primary,
      scheduleIconColor: Colors.blue,
      enabledStateColor: Colors.green,
      disabledStateColor: Colors.red,
      mutedTextColor: theme.colorScheme.onSurfaceVariant,
      cardTitleStyle: theme.textTheme.titleMedium!,
      valueTextStyle: theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      subtitleTextStyle: theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.secondary,
      ),
      statusTextStyle: theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  // Dark theme
  static AppTheme dark(ThemeData theme) {
    return AppTheme(
      activeZoneColor: Colors.lightBlue,
      inactiveZoneColor: Colors.grey.shade700,
      weatherIconColor: theme.colorScheme.primary,
      scheduleIconColor: Colors.lightBlue,
      enabledStateColor: Colors.lightGreen,
      disabledStateColor: Colors.redAccent,
      mutedTextColor: theme.colorScheme.onSurfaceVariant,
      cardTitleStyle: theme.textTheme.titleMedium!,
      valueTextStyle: theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      subtitleTextStyle: theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.secondary,
      ),
      statusTextStyle: theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
} 