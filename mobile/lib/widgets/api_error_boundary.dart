import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/connection_error_provider.dart';

/// A widget that catches API errors and shows the connection settings screen
/// when needed
class ApiErrorBoundary extends ConsumerStatefulWidget {
  final Widget child;

  const ApiErrorBoundary({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ApiErrorBoundary> createState() => _ApiErrorBoundaryState();
}

class _ApiErrorBoundaryState extends ConsumerState<ApiErrorBoundary> {
  @override
  void initState() {
    super.initState();
    // Set up the global error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      // Handle the error after the frame is done
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(connectionErrorProvider.notifier).handleError(
          context,
          details.exception,
        );
      });
    };
  }

  @override
  Widget build(BuildContext context) => widget.child;
} 