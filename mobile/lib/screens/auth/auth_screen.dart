import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_cookie_jar/webview_cookie_jar.dart';
import '../../providers/connection_state_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final redirectUrl = ref.read(connectionStateProvider).authRedirectUrl;
    if (redirectUrl == null) {
      return;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) async {
            setState(() => _isLoading = false);
            final cookies = await WebViewCookieJar.cookieJar.loadForRequest(Uri.parse(url));
            final hasSessionToken = cookies.any((cookie) => cookie.name == 'session-token');
            if (hasSessionToken) {
              ref.read(connectionStateProvider.notifier).reset();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(redirectUrl));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            'Authentication Required',
            style: theme.textTheme.titleLarge,
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(connectionStateProvider.notifier).reset();
            },
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
} 