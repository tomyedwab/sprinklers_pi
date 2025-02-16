import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/connection_settings.dart';
import '../../providers/connection_settings_provider.dart';
import '../../api/api_client.dart';
import '../../api/api_config.dart';
import '../../navigation/app_router.dart';

class ConnectionSettingsScreen extends ConsumerStatefulWidget {
  /// If true, this screen was shown due to a connection error
  final bool isError;

  const ConnectionSettingsScreen({
    super.key,
    this.isError = false,
  });

  @override
  ConsumerState<ConnectionSettingsScreen> createState() => _ConnectionSettingsScreenState();
}

class _ConnectionSettingsScreenState extends ConsumerState<ConnectionSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  bool _isValidating = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with current URL if it exists
    _urlController.text = ref.read(connectionSettingsProvider).baseUrl;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  String? _validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a URL';
    }
    try {
      final uri = Uri.parse(value);
      if (!uri.isAbsolute) {
        return 'Please enter a complete URL (including http:// or https://)';
      }
      if (!uri.hasAuthority) {
        return 'Please enter a valid server address';
      }
      return null;
    } catch (e) {
      return 'Please enter a valid URL';
    }
  }

  Future<bool> _testConnection(String url) async {
    setState(() => _isValidating = true);
    final originalUrl = ref.read(connectionSettingsProvider).baseUrl;
    
    try {
      // Temporarily set the API URL for testing
      ApiConfig.setBaseUrl(url);
      
      // Create a temporary API client
      final testClient = ApiClient();
      
      // Try to get the system state as a connection test
      await testClient.getSystemState();
      return true;
    } catch (e) {
      // Only restore the original URL if the test failed and we had a previous URL
      if (originalUrl.isNotEmpty) {
        ApiConfig.setBaseUrl(originalUrl);
      }
      return false;
    } finally {
      setState(() => _isValidating = false);
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    final url = _urlController.text.trim();
    if (!await _testConnection(url)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not connect to server. Please check the URL and try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Save the settings
    await ref.read(connectionSettingsProvider.notifier).updateSettings(
      ConnectionSettings(baseUrl: url),
    );

    if (!mounted) return;
    
    // Hide the connection settings screen using the router
    final router = Router.of(context).routerDelegate as AppRouterDelegate;
    router.hideConnectionSettings();
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connected successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection Settings'),
        // Only show back button if this wasn't opened due to an error
        automaticallyImplyLeading: !widget.isError,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (widget.isError) ...[
              const Card(
                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.white, size: 48),
                      SizedBox(height: 16),
                      Text(
                        'Connection Error',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please check your connection settings and ensure the Sprinklers Pi server is running.',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Server URL',
                hintText: 'http://192.168.1.100:8080',
                helperText: 'Enter the full URL of your Sprinklers Pi server',
                border: OutlineInputBorder(),
              ),
              validator: _validateUrl,
              enabled: !_isValidating,
              autocorrect: false,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isValidating ? null : _saveSettings,
              child: _isValidating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save and Test Connection'),
            ),
          ],
        ),
      ),
    );
  }
} 