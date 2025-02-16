import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../screens/auth/auth_screen.dart';

final authProvider = NotifierProvider<AuthNotifier, bool>(
  () => AuthNotifier(),
);

class AuthNotifier extends Notifier<bool> {
  String? _pendingRedirect;
  Completer<bool>? _authCompleter;
  
  @override
  bool build() => false;  // Initially not showing auth screen

  /// Get the current redirect URL if there is one
  String? get pendingRedirect => _pendingRedirect;

  /// Show the auth screen with the given redirect URL and wait for completion
  Future<bool> authenticate(String redirectUrl, BuildContext context) async {
    _pendingRedirect = redirectUrl;
    state = true;
    
    // Create a completer to wait for auth result
    _authCompleter = Completer<bool>();
    
    // Show the auth screen using a dialog to preserve the current screen state
    if (!context.mounted) return false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AuthScreen(),
    );
    
    // Return the auth result (true if completed, false if cancelled)
    return _authCompleter?.future ?? Future.value(false);
  }

  /// Hide the auth screen
  void hideAuthScreen(BuildContext context, {bool success = true}) {
    _pendingRedirect = null;
    state = false;
    _authCompleter?.complete(success);
    _authCompleter = null;
    Navigator.of(context).pop();  // Close the dialog
  }

  /// Handle an API error, showing the auth screen if needed
  Future<bool> handleApiError(BuildContext context, Object error) async {
    if (error is ApiException && error.isRedirect) {
      final redirectUrl = error.redirectLocation;
      if (redirectUrl != null) {
        return authenticate(redirectUrl, context);
      }
    }
    return false;
  }
} 