import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/settings.dart';
import '../../models/connection_settings.dart';
import '../../providers/settings_provider.dart';
import '../../providers/connection_settings_provider.dart';
import '../../navigation/app_router.dart';
import '../../widgets/loading_states.dart';
import '../../widgets/standard_error_widget.dart';
import '../../widgets/confirmation_dialogs.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _hasUnsavedChanges = false;
  
  // Form controllers
  late final TextEditingController _webPortController;
  late final TextEditingController _weatherServiceIpController;
  late final TextEditingController _weatherApiSecretController;
  late final TextEditingController _locationController;
  late final TextEditingController _seasonalAdjustmentController;

  // Form values that aren't text fields
  OutputType _outputType = OutputType.none;

  @override
  void initState() {
    super.initState();
    _webPortController = TextEditingController();
    _weatherServiceIpController = TextEditingController();
    _weatherApiSecretController = TextEditingController();
    _locationController = TextEditingController();
    _seasonalAdjustmentController = TextEditingController();

    // Add listeners to detect changes
    _webPortController.addListener(_onFormChanged);
    _weatherServiceIpController.addListener(_onFormChanged);
    _weatherApiSecretController.addListener(_onFormChanged);
    _locationController.addListener(_onFormChanged);
    _seasonalAdjustmentController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _webPortController.dispose();
    _weatherServiceIpController.dispose();
    _weatherApiSecretController.dispose();
    _locationController.dispose();
    _seasonalAdjustmentController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  void _updateFormFromSettings(Settings settings) {
    _webPortController.text = settings.webPort.toString();
    _weatherServiceIpController.text = settings.weatherServiceIp;
    _weatherApiSecretController.text = settings.weatherApiSecret ?? '';
    _locationController.text = settings.location ?? '';
    _seasonalAdjustmentController.text = settings.seasonalAdjustment.toString();
    setState(() {
      _outputType = settings.outputType;
      _hasUnsavedChanges = false;
    });
  }

  Settings _buildSettingsFromForm() {
    return Settings(
      webPort: int.parse(_webPortController.text),
      outputType: _outputType,
      weatherServiceIp: _weatherServiceIpController.text,
      weatherApiSecret: _weatherApiSecretController.text.isEmpty ? null : _weatherApiSecretController.text,
      location: _locationController.text.isEmpty ? null : _locationController.text,
      seasonalAdjustment: int.parse(_seasonalAdjustmentController.text),
    );
  }

  Future<void> _confirmDiscard() async {
    if (!_hasUnsavedChanges) return;

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

    if (shouldDiscard == true && mounted) {
      ref.invalidate(settingsNotifierProvider);
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const StandardErrorWidget(
            message: 'Please fix the errors in the form',
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
      final settings = _buildSettingsFromForm();
      await ref.read(settingsNotifierProvider.notifier).saveSettings(settings);
      if (mounted) {
        setState(() => _hasUnsavedChanges = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Settings saved successfully',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: StandardErrorWidget(
              message: 'Failed to save settings',
              type: ErrorType.network,
              showRetry: true,
              onPrimaryAction: _saveSettings,
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

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsNotifierProvider);
    final theme = Theme.of(context);

    // Update form whenever we get new settings data
    ref.listen<AsyncValue<Settings>>(settingsNotifierProvider, (previous, next) {
      next.whenData(_updateFormFromSettings);
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge,
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: theme.colorScheme.secondary,
            ),
            onPressed: _confirmDiscard,
          ),
          IconButton(
            icon: Icon(
              Icons.save,
              color: _hasUnsavedChanges ? theme.colorScheme.secondary : theme.colorScheme.secondary.withOpacity(0.5),
            ),
            onPressed: _hasUnsavedChanges ? _saveSettings : null,
          ),
        ],
      ),
      body: settingsAsync.when(
        data: (settings) => Form(
          key: _formKey,
          onWillPop: () async {
            if (!_hasUnsavedChanges) return true;
            await _confirmDiscard();
            return false;
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Network Configuration
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Network Configuration',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _webPortController,
                        decoration: InputDecoration(
                          labelText: 'Web Port',
                          hintText: 'Enter web port (0-32767)',
                          labelStyle: TextStyle(color: theme.colorScheme.secondary),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.primary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.5)),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Web port is required';
                          }
                          final port = int.tryParse(value);
                          if (port == null || port < 0 || port > 32767) {
                            return 'Port must be between 0 and 32767';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // Weather Service Configuration
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weather Service',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _weatherServiceIpController,
                        decoration: InputDecoration(
                          labelText: 'Weather Service IP',
                          hintText: 'Enter Weather Underground service IP',
                          labelStyle: TextStyle(color: theme.colorScheme.secondary),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.primary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.5)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Weather service IP is required';
                          }
                          // Add IP address format validation
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _weatherApiSecretController,
                        decoration: InputDecoration(
                          labelText: 'Weather API Secret (Optional)',
                          hintText: 'Enter Weather Underground API secret',
                          labelStyle: TextStyle(color: theme.colorScheme.secondary),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.primary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Location (Optional)',
                          hintText: 'Enter location coordinates (latitude,longitude)',
                          labelStyle: TextStyle(color: theme.colorScheme.secondary),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.primary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // System Configuration
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'System Configuration',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<OutputType>(
                        value: _outputType,
                        decoration: InputDecoration(
                          labelText: 'Output Type',
                          labelStyle: TextStyle(color: theme.colorScheme.secondary),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.primary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.5)),
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
                        onChanged: (OutputType? value) {
                          if (value != null) {
                            setState(() {
                              _outputType = value;
                              _hasUnsavedChanges = true;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _seasonalAdjustmentController,
                        decoration: InputDecoration(
                          labelText: 'Seasonal Adjustment',
                          hintText: 'Enter adjustment (0-200%)',
                          suffixText: '%',
                          labelStyle: TextStyle(color: theme.colorScheme.secondary),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.primary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.5)),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seasonal adjustment is required';
                          }
                          final adjustment = int.tryParse(value);
                          if (adjustment == null || adjustment < 0 || adjustment > 200) {
                            return 'Adjustment must be between 0 and 200';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              // Logout Button
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connection',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () async {
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

                          if (shouldLogout == true && mounted) {
                            // Clear the connection settings
                            await ref.read(connectionSettingsProvider.notifier).updateSettings(
                              ConnectionSettings.defaultSettings,
                            );

                            if (!mounted) return;

                            // Show the connection settings screen
                            final router = Router.of(context).routerDelegate as AppRouterDelegate;
                            router.showConnectionSettings();
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: 3,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: SkeletonCard(
              height: index == 0 ? 80 : 160,
              showHeader: true,
              contentLines: index == 0 ? 1 : 3,
              showActions: false,
            ),
          ),
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
} 