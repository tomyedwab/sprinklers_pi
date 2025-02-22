import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_cookie_jar/webview_cookie_jar.dart';
import 'package:sprinklers_pi/api/api_config.dart';
import '../../models/settings.dart';
import '../../models/connection_settings.dart';
import '../../providers/settings_provider.dart';
import '../../providers/settings_form_provider.dart';
import '../../providers/connection_settings_provider.dart';
import '../../navigation/app_router.dart';
import '../../widgets/loading_states.dart';
import '../../widgets/standard_error_widget.dart';
import '../../widgets/confirmation_dialogs.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);
    final formState = ref.watch(settingsFormProvider);
    final formNotifier = ref.watch(settingsFormProvider.notifier);
    final theme = Theme.of(context);
    final appTheme = AppTheme.of(context);

    // Update form when settings change
    ref.listen<AsyncValue<Settings>>(settingsNotifierProvider, (previous, next) {
      next.whenData(formNotifier.updateFromSettings);
    });

    Future<void> _handleRefresh() async {
      if (formState.hasUnsavedChanges) {
        final shouldDiscard = await _confirmDiscard(context, formNotifier);
        if (!shouldDiscard) return;
      }
      ref.refresh(settingsNotifierProvider);
    }

    Widget buildFormField({
      required String fieldName,
      required Widget child,
    }) {
      return Stack(
        children: [
          Opacity(
            opacity: formState.isFieldEnabled(fieldName) ? 1.0 : 0.5,
            child: IgnorePointer(
              ignoring: !formState.isFieldEnabled(fieldName),
              child: child,
            ),
          ),
          if (!formState.isFieldEnabled(fieldName))
            Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Settings',
          style: appTheme.cardTitleStyle,
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: !formState.isSaving 
                ? theme.colorScheme.secondary 
                : appTheme.mutedTextColor,
            ),
            onPressed: !formState.isSaving ? _handleRefresh : null,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.save,
                  color: formState.hasUnsavedChanges && formState.isValid && !formState.isSaving
                    ? theme.colorScheme.secondary 
                    : appTheme.mutedTextColor,
                ),
                onPressed: formState.hasUnsavedChanges && formState.isValid && !formState.isSaving
                  ? () => _saveSettings(context, formNotifier)
                  : null,
              ),
              if (formState.isSaving)
                Positioned.fill(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ],
      ),
      body: settingsAsync.when(
        data: (_) => Form(
          onWillPop: () async {
            if (!formState.hasUnsavedChanges) return true;
            return _confirmDiscard(context, formNotifier);
          },
          child: ListView(
            padding: Spacing.screenPaddingAll,
            children: [
              // Network Configuration
              Card(
                child: Padding(
                  padding: Spacing.cardPaddingAll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Network Configuration',
                        style: appTheme.cardTitleStyle,
                      ),
                      SizedBox(height: Spacing.md),
                      buildFormField(
                        fieldName: 'webPort',
                        child: TextFormField(
                          controller: formState.webPortController,
                          decoration: InputDecoration(
                            labelText: 'Web Port',
                            hintText: 'Enter web port (0-32767)',
                            labelStyle: appTheme.subtitleTextStyle,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: theme.colorScheme.primary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: appTheme.mutedTextColor),
                            ),
                            errorText: formState.fieldErrors['webPort'],
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: Spacing.cardSpacing),
              // Weather Service Configuration
              Card(
                child: Padding(
                  padding: Spacing.cardPaddingAll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weather Service',
                        style: appTheme.cardTitleStyle,
                      ),
                      SizedBox(height: Spacing.md),
                      buildFormField(
                        fieldName: 'weatherServiceIp',
                        child: TextFormField(
                          controller: formState.weatherServiceIpController,
                          decoration: InputDecoration(
                            labelText: 'Weather Service IP',
                            hintText: 'Enter Weather Underground service IP',
                            labelStyle: appTheme.subtitleTextStyle,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: theme.colorScheme.primary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: appTheme.mutedTextColor),
                            ),
                            errorText: formState.fieldErrors['weatherServiceIp'],
                          ),
                        ),
                      ),
                      SizedBox(height: Spacing.md),
                      buildFormField(
                        fieldName: 'weatherApiSecret',
                        child: TextFormField(
                          controller: formState.weatherApiSecretController,
                          decoration: InputDecoration(
                            labelText: 'Weather API Secret (Optional)',
                            hintText: 'Enter Weather Underground API secret',
                            labelStyle: appTheme.subtitleTextStyle,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: theme.colorScheme.primary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: appTheme.mutedTextColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Spacing.md),
                      buildFormField(
                        fieldName: 'location',
                        child: TextFormField(
                          controller: formState.locationController,
                          decoration: InputDecoration(
                            labelText: 'Location (Optional)',
                            hintText: 'Enter location coordinates (latitude,longitude)',
                            labelStyle: appTheme.subtitleTextStyle,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: theme.colorScheme.primary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: appTheme.mutedTextColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: Spacing.cardSpacing),
              // System Configuration
              Card(
                child: Padding(
                  padding: Spacing.cardPaddingAll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'System Configuration',
                        style: appTheme.cardTitleStyle,
                      ),
                      SizedBox(height: Spacing.md),
                      DropdownButtonFormField<OutputType>(
                        value: formState.outputType,
                        decoration: InputDecoration(
                          labelText: 'Output Type',
                          labelStyle: appTheme.subtitleTextStyle,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.primary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: appTheme.mutedTextColor),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: OutputType.none,
                            child: Text('None'),
                          ),
                          DropdownMenuItem(
                            value: OutputType.directPositive,
                            child: Text('Direct+'),
                          ),
                          DropdownMenuItem(
                            value: OutputType.directNegative,
                            child: Text('Direct-'),
                          ),
                          DropdownMenuItem(
                            value: OutputType.openSprinkler,
                            child: Text('OpenSprinkler'),
                          ),
                        ],
                        onChanged: formNotifier.setOutputType,
                      ),
                      SizedBox(height: Spacing.md),
                      buildFormField(
                        fieldName: 'seasonalAdjustment',
                        child: TextFormField(
                          controller: formState.seasonalAdjustmentController,
                          decoration: InputDecoration(
                            labelText: 'Seasonal Adjustment',
                            hintText: 'Enter adjustment (0-200%)',
                            suffixText: '%',
                            labelStyle: appTheme.subtitleTextStyle,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: theme.colorScheme.primary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: appTheme.mutedTextColor),
                            ),
                            errorText: formState.fieldErrors['seasonalAdjustment'],
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: Spacing.sectionSpacing),
              // Logout Button
              Card(
                child: Padding(
                  padding: Spacing.cardPaddingAll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connection',
                        style: appTheme.cardTitleStyle,
                      ),
                      SizedBox(height: Spacing.md),
                      FilledButton.icon(
                        onPressed: formState.isSaving ? null : () => _handleLogout(context, ref),
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          minimumSize: Size(double.infinity, Spacing.xxl),
                        ),
                        icon: Icon(Icons.logout, color: theme.colorScheme.onError),
                        label: Text(
                          'Logout',
                          style: appTheme.valueTextStyle.copyWith(
                            color: theme.colorScheme.onError,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Spacing.sectionSpacing),
            ],
          ),
        ),
        loading: () => ListView(
          padding: Spacing.screenPaddingAll,
          children: [
            // Network Configuration Skeleton
            SkeletonCard(
              height: 120,
              showHeader: true,
              contentLines: 1,
              showActions: false,
            ),
            SizedBox(height: Spacing.cardSpacing),
            // Weather Service Skeleton
            SkeletonCard(
              height: 280,
              showHeader: true,
              contentLines: 3,
              showActions: false,
            ),
            SizedBox(height: Spacing.cardSpacing),
            // System Configuration Skeleton
            SkeletonCard(
              height: 200,
              showHeader: true,
              contentLines: 2,
              showActions: false,
            ),
            SizedBox(height: Spacing.sectionSpacing),
            // Connection Skeleton
            SkeletonCard(
              height: 120,
              showHeader: true,
              contentLines: 1,
              showActions: true,
            ),
          ],
        ),
        error: (error, stack) => Center(
          child: StandardErrorWidget(
            message: 'Failed to load settings',
            type: ErrorType.network,
            showRetry: true,
            onPrimaryAction: () => ref.refresh(settingsNotifierProvider),
          ),
        ),
      ),
    );
  }

  Future<void> _saveSettings(
    BuildContext context,
    SettingsFormNotifier formNotifier,
  ) async {
    final formState = formNotifier.state;
    if (!formState.isValid) {
      final errors = formState.fieldErrors.values.join('\n');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: StandardErrorWidget(
            message: 'Please fix the following errors:\n$errors',
            type: ErrorType.validation,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      await formNotifier.saveSettings();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: StandardErrorWidget(
              message: 'Settings saved successfully',
              type: ErrorType.success,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: StandardErrorWidget(
              message: 'Failed to save settings',
              type: ErrorType.network,
              showRetry: true,
              onPrimaryAction: () => _saveSettings(context, formNotifier),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<bool> _confirmDiscard(BuildContext context, SettingsFormNotifier formNotifier) async {
    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmActionDialog(
        title: 'Discard Changes',
        message: 'You have unsaved changes. Are you sure you want to discard them?',
        confirmText: 'Discard',
        icon: Icons.delete_outline,
        isDestructive: true,
      ),
    );

    if (shouldDiscard == true) {
      formNotifier.discardChanges();
      return true;
    }
    return false;
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmActionDialog(
        title: 'Logout',
        message: 'Are you sure you want to disconnect from the server?',
        confirmText: 'Logout',
        icon: Icons.logout,
        isDestructive: true,
      ),
    );

    if (shouldLogout == true && context.mounted) {
      try {
        // Clear the cookies
        await WebViewCookieJar.cookieJar.deleteAll();
        
        // Clear the connection settings
        await ref.read(connectionSettingsProvider.notifier).updateSettings(
          ConnectionSettings.defaultSettings,
        );

        if (!context.mounted) return;

        // Show the connection settings screen
        final router = Router.of(context).routerDelegate as AppRouterDelegate;
        router.showConnectionSettings();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: StandardErrorWidget(
                message: 'Failed to logout. Please try again.',
                type: ErrorType.network,
                showRetry: true,
                onPrimaryAction: () => _handleLogout(context, ref),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
} 