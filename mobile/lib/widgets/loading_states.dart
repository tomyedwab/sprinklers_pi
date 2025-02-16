import 'package:flutter/material.dart';

/// A widget that creates a shimmering loading effect
class ShimmerEffect extends StatefulWidget {
  /// Child widget to apply shimmer effect to
  final Widget child;

  /// Base color for the shimmer effect
  final Color? baseColor;

  /// Highlight color for the shimmer effect
  final Color? highlightColor;

  /// Duration of one complete shimmer animation
  final Duration duration;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = widget.baseColor ??
        theme.colorScheme.surfaceVariant.withOpacity(0.3);
    final highlightColor = widget.highlightColor ??
        theme.colorScheme.surfaceVariant;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              transform: _SlidingGradientTransform(_animation.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Transform class for sliding gradient animation
class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// A skeleton loading card with shimmer effect
class SkeletonCard extends StatelessWidget {
  /// Height of the card
  final double height;

  /// Width of the card (defaults to match parent)
  final double? width;

  /// Whether to show a header section
  final bool showHeader;

  /// Number of lines to show in the content
  final int contentLines;

  /// Whether to show an action section at the bottom
  final bool showActions;

  /// Custom padding for the card
  final EdgeInsetsGeometry? padding;

  const SkeletonCard({
    super.key,
    this.height = 120,
    this.width,
    this.showHeader = true,
    this.contentLines = 3,
    this.showActions = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Container(
        height: height,
        width: width,
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) ...[
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 100,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(contentLines, (index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: index == contentLines - 1 ? 0 : 8),
                    child: Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),
            if (showActions) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 80,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 80,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A widget that shows a loading error with retry option
class LoadingErrorRetry extends StatelessWidget {
  /// The error message to display
  final String message;

  /// Callback when retry is pressed
  final VoidCallback? onRetry;

  /// Optional icon to display
  final IconData? icon;

  const LoadingErrorRetry({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 