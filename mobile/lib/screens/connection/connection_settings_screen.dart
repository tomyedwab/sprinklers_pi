import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/connection_settings.dart';
import '../../providers/connection_settings_provider.dart';
import '../../api/api_client.dart';
import '../../api/api_config.dart';
import '../../navigation/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/message_card.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';

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
    ref.read(connectionSettingsProvider).whenData((settings) {
      _urlController.text = settings.baseUrl;
    });
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
    String? originalUrl;
    
    // Get the current settings if they exist
    ref.read(connectionSettingsProvider).whenData((settings) {
      originalUrl = settings.baseUrl;
    });
    
    // Create a temporary API client
    final testClient = ApiClient();
    
    try {
      // Temporarily set the API URL for testing
      ApiConfig.setBaseUrl(url);
      
      // Try to get the system state as a connection test
      await testClient.getSystemState();
      return true;
    } catch (e) {
      if (e is ApiException && e.isRedirect) {
        // If we got a redirect, that means the server is reachable
        // Show the auth screen and wait for completion
        if (!mounted) return false;
        final authSuccess = await ref.read(authProvider.notifier).handleApiError(context, e);
        
        if (authSuccess) {
          // Try the connection test again after successful authentication
          try {
            await testClient.getSystemState();
            return true;
          } catch (retryError) {
            // If we still get an error after auth, treat it as a connection failure
            if (originalUrl?.isNotEmpty ?? false) {
              ApiConfig.setBaseUrl(originalUrl!);
            }
            return false;
          }
        }
      }

      // Only restore the original URL if the test failed and we had a previous URL
      if (originalUrl?.isNotEmpty ?? false) {
        ApiConfig.setBaseUrl(originalUrl!);
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

  Future<void> _openDocumentation() async {
    final docUrl = Uri.parse('https://github.com/rszimm/sprinklers_pi/wiki');
    try {
      await launchUrl(
        docUrl,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open documentation: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(connectionSettingsProvider);
    final theme = Theme.of(context);
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Connection Settings',
          style: appTheme.cardTitleStyle,
        ),
        elevation: 2,
        automaticallyImplyLeading: !widget.isError,
      ),
      body: settingsAsync.when(
        data: (settings) => Form(
          key: _formKey,
          child: ListView(
            padding: Spacing.screenPaddingAll,
            children: [
              if (widget.isError && settings.baseUrl.isNotEmpty) ...[
                MessageCard(
                  icon: Icons.error_outline,
                  title: 'Connection Error',
                  message: 'Please check your connection settings and ensure the Sprinklers Pi server is running.',
                  primaryColor: theme.colorScheme.error,
                  textColor: Colors.white,
                ),
                SizedBox(height: Spacing.md),
              ] else if (settings.baseUrl.isEmpty) ...[
                MessageCard(
                  icon: Icons.wifi_find,
                  title: 'Welcome to Sprinklers Pi',
                  message: 'Please enter the URL of your Sprinklers Pi server to get started. Check the documentation for help with server setup.',
                  primaryColor: theme.colorScheme.primary,
                  docLink: 'https://github.com/rszimm/sprinklers_pi/wiki',
                  onDocLinkTap: _openDocumentation,
                ),
                SizedBox(height: Spacing.md),
              ],
              Card(
                child: Padding(
                  padding: Spacing.cardPaddingAll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Server Connection',
                        style: appTheme.cardTitleStyle,
                      ),
                      SizedBox(height: Spacing.md),
                      TextFormField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          labelText: 'Server URL',
                          hintText: 'http://192.168.1.100:8080',
                          helperText: 'Enter the full URL of your Sprinklers Pi server',
                          helperStyle: appTheme.subtitleTextStyle,
                          border: const OutlineInputBorder(),
                          labelStyle: TextStyle(color: theme.colorScheme.secondary),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.primary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.5)),
                          ),
                        ),
                        validator: _validateUrl,
                        enabled: !_isValidating,
                        autocorrect: false,
                        keyboardType: TextInputType.url,
                      ),
                      SizedBox(height: Spacing.md),
                      FilledButton(
                        onPressed: _isValidating ? null : _saveSettings,
                        style: FilledButton.styleFrom(
                          minimumSize: Size(double.infinity, Spacing.xxl),
                        ),
                        child: _isValidating
                            ? SizedBox(
                                height: Spacing.lg,
                                width: Spacing.lg,
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
              ),
            ],
          ),
        ),
        loading: () => Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: Spacing.screenPaddingAll,
            child: MessageCard(
              icon: Icons.error_outline,
              title: 'Error Loading Settings',
              message: error.toString(),
              primaryColor: theme.colorScheme.error,
            ),
          ),
        ),
      ),
    );
  }
} 