import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings.dart';
import 'settings_provider.dart';

class SettingsFormState {
  final TextEditingController webPortController;
  final TextEditingController weatherServiceIpController;
  final TextEditingController weatherApiSecretController;
  final TextEditingController locationController;
  final TextEditingController seasonalAdjustmentController;
  final OutputType outputType;
  final bool hasUnsavedChanges;
  final bool isValid;
  final Map<String, String> fieldErrors;
  final bool isSaving;
  final Set<String> loadingFields;

  SettingsFormState({
    required this.webPortController,
    required this.weatherServiceIpController,
    required this.weatherApiSecretController,
    required this.locationController,
    required this.seasonalAdjustmentController,
    required this.outputType,
    required this.hasUnsavedChanges,
    required this.isValid,
    required this.fieldErrors,
    required this.isSaving,
    required this.loadingFields,
  });

  bool isFieldEnabled(String fieldName) {
    return !isSaving && !loadingFields.contains(fieldName);
  }

  SettingsFormState copyWith({
    OutputType? outputType,
    bool? hasUnsavedChanges,
    bool? isValid,
    Map<String, String>? fieldErrors,
    bool? isSaving,
    Set<String>? loadingFields,
  }) {
    return SettingsFormState(
      webPortController: webPortController,
      weatherServiceIpController: weatherServiceIpController,
      weatherApiSecretController: weatherApiSecretController,
      locationController: locationController,
      seasonalAdjustmentController: seasonalAdjustmentController,
      outputType: outputType ?? this.outputType,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      isValid: isValid ?? this.isValid,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      isSaving: isSaving ?? this.isSaving,
      loadingFields: loadingFields ?? this.loadingFields,
    );
  }

  void dispose() {
    webPortController.dispose();
    weatherServiceIpController.dispose();
    weatherApiSecretController.dispose();
    locationController.dispose();
    seasonalAdjustmentController.dispose();
  }
}

class SettingsFormNotifier extends StateNotifier<SettingsFormState> {
  final Ref ref;

  SettingsFormNotifier(this.ref) : super(SettingsFormState(
    webPortController: TextEditingController(),
    weatherServiceIpController: TextEditingController(),
    weatherApiSecretController: TextEditingController(),
    locationController: TextEditingController(),
    seasonalAdjustmentController: TextEditingController(),
    outputType: OutputType.none,
    hasUnsavedChanges: false,
    isValid: false,
    fieldErrors: {},
    isSaving: false,
    loadingFields: {},
  )) {
    _initializeControllers();
  }

  void _initializeControllers() {
    // Add listeners to all controllers
    void onChanged() => _onFormChanged();
    
    state.webPortController.addListener(onChanged);
    state.weatherServiceIpController.addListener(onChanged);
    state.weatherApiSecretController.addListener(onChanged);
    state.locationController.addListener(onChanged);
    state.seasonalAdjustmentController.addListener(onChanged);
  }

  void _onFormChanged() {
    if (!state.hasUnsavedChanges) {
      state = state.copyWith(hasUnsavedChanges: true);
    }
    validateForm();
  }

  void validateForm() {
    final errors = <String, String>{};
    
    // Validate web port
    final webPortError = _validateWebPort();
    if (webPortError != null) {
      errors['webPort'] = webPortError;
    }

    // Validate weather service IP
    final weatherServiceIpError = _validateWeatherServiceIp();
    if (weatherServiceIpError != null) {
      errors['weatherServiceIp'] = weatherServiceIpError;
    }

    // Validate seasonal adjustment
    final seasonalAdjustmentError = _validateSeasonalAdjustment();
    if (seasonalAdjustmentError != null) {
      errors['seasonalAdjustment'] = seasonalAdjustmentError;
    }

    state = state.copyWith(
      isValid: errors.isEmpty,
      fieldErrors: errors,
    );
  }

  String? _validateWebPort() {
    final value = state.webPortController.text;
    if (value.isEmpty) {
      return 'Web port is required';
    }
    final port = int.tryParse(value);
    if (port == null || port < 0 || port > 32767) {
      return 'Port must be between 0 and 32767';
    }
    return null;
  }

  String? _validateWeatherServiceIp() {
    final value = state.weatherServiceIpController.text;
    if (value.isEmpty) {
      return 'Weather service IP is required';
    }
    // Add IP address format validation if needed
    return null;
  }

  String? _validateSeasonalAdjustment() {
    final value = state.seasonalAdjustmentController.text;
    if (value.isEmpty) {
      return 'Seasonal adjustment is required';
    }
    final adjustment = int.tryParse(value);
    if (adjustment == null || adjustment < 0 || adjustment > 200) {
      return 'Adjustment must be between 0 and 200';
    }
    return null;
  }

  void setOutputType(OutputType? type) {
    if (type != null && type != state.outputType) {
      state = state.copyWith(
        outputType: type,
        hasUnsavedChanges: true,
      );
    }
  }

  void updateFromSettings(Settings settings) {
    state.webPortController.text = settings.webPort.toString();
    state.weatherServiceIpController.text = settings.weatherServiceIp;
    state.weatherApiSecretController.text = settings.weatherApiSecret ?? '';
    state.locationController.text = settings.location ?? '';
    state.seasonalAdjustmentController.text = settings.seasonalAdjustment.toString();
    
    state = state.copyWith(
      outputType: settings.outputType,
      hasUnsavedChanges: false,
    );
  }

  Settings buildSettings() {
    return Settings(
      webPort: int.parse(state.webPortController.text),
      outputType: state.outputType,
      weatherServiceIp: state.weatherServiceIpController.text,
      weatherApiSecret: state.weatherApiSecretController.text.isEmpty 
        ? null 
        : state.weatherApiSecretController.text,
      location: state.locationController.text.isEmpty 
        ? null 
        : state.locationController.text,
      seasonalAdjustment: int.parse(state.seasonalAdjustmentController.text),
    );
  }

  Future<void> saveSettings() async {
    if (!state.isValid) return;
    
    state = state.copyWith(isSaving: true);
    try {
      final settings = buildSettings();
      await ref.read(settingsNotifierProvider.notifier).saveSettings(settings);
      if (mounted) {
        state = state.copyWith(
          hasUnsavedChanges: false,
          isSaving: false,
        );
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(isSaving: false);
      }
      rethrow;
    }
  }

  void discardChanges() {
    final settings = ref.read(settingsNotifierProvider).value;
    if (settings != null) {
      updateFromSettings(settings);
    }
  }

  void setFieldLoading(String fieldName, bool isLoading) {
    final loadingFields = Set<String>.from(state.loadingFields);
    if (isLoading) {
      loadingFields.add(fieldName);
    } else {
      loadingFields.remove(fieldName);
    }
    state = state.copyWith(loadingFields: loadingFields);
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}

final settingsFormProvider = StateNotifierProvider<SettingsFormNotifier, SettingsFormState>((ref) {
  return SettingsFormNotifier(ref);
}); 