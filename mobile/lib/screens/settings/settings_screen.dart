import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/settings.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/loading_overlay.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  
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

  void _updateFormFromSettings(Settings settings) {
    _webPortController.text = settings.webPort.toString();
    _weatherServiceIpController.text = settings.weatherServiceIp;
    _weatherApiSecretController.text = settings.weatherApiSecret ?? '';
    _locationController.text = settings.location ?? '';
    _seasonalAdjustmentController.text = settings.seasonalAdjustment.toString();
    setState(() {
      _outputType = settings.outputType;
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

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    final settings = _buildSettingsFromForm();
    await ref.read(settingsNotifierProvider.notifier).saveSettings(settings);
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    // Update form whenever we get new settings data
    ref.listen<AsyncValue<Settings>>(settingsNotifierProvider, (previous, next) {
      next.whenData(_updateFormFromSettings);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(settingsNotifierProvider),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: settingsAsync.when(
        data: (settings) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Network Configuration
              const Text('Network Configuration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _webPortController,
                decoration: const InputDecoration(
                  labelText: 'Web Port',
                  hintText: 'Enter web port (0-32767)',
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

              const SizedBox(height: 24),
              // Weather Service Configuration
              const Text('Weather Service', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weatherServiceIpController,
                decoration: const InputDecoration(
                  labelText: 'Weather Service IP',
                  hintText: 'Enter Weather Underground service IP',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Weather service IP is required';
                  }
                  // Add IP address format validation
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _weatherApiSecretController,
                decoration: const InputDecoration(
                  labelText: 'Weather API Secret (Optional)',
                  hintText: 'Enter Weather Underground API secret',
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (Optional)',
                  hintText: 'Enter location coordinates (latitude,longitude)',
                ),
              ),

              const SizedBox(height: 24),
              // System Configuration
              const Text('System Configuration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<OutputType>(
                value: _outputType,
                decoration: const InputDecoration(
                  labelText: 'Output Type',
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
                    });
                  }
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _seasonalAdjustmentController,
                decoration: const InputDecoration(
                  labelText: 'Seasonal Adjustment',
                  hintText: 'Enter adjustment (0-200%)',
                  suffixText: '%',
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
        loading: () => const LoadingOverlay(),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
} 