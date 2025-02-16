import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/connection_error_provider.dart';
import '../providers/connection_settings_provider.dart';

/// A widget that checks the connection when the app starts
/// and shows the connection settings screen if needed
class ConnectionChecker extends ConsumerStatefulWidget {
  final Widget child;

  const ConnectionChecker({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ConnectionChecker> createState() => _ConnectionCheckerState();
}

class _ConnectionCheckerState extends ConsumerState<ConnectionChecker> {
  @override
  void initState() {
    super.initState();
    // Schedule the check for after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only check connection if we have a base URL configured
      final settings = ref.read(connectionSettingsProvider);
      if (settings.baseUrl.isNotEmpty) {
        ref.read(connectionErrorProvider.notifier).checkInitialConnection(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
} 