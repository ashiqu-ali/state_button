import 'package:flutter/material.dart';

/// A progressive dots loading indicator where dots move from right to left
/// while the leading dot fades out and a new dot appears at the end.
///
/// This creates a continuous flowing "typing" or "loading" effect.
///
/// Uses a single [AnimationController] and interval-based animations
/// to keep performance efficient and consistent with other loaders.
class SbProgressiveDots extends StatefulWidget {
  /// Creates a progressive dots loader with the given [size] and [color].
  const SbProgressiveDots({
    super.key,
    required this.size,
    required this.color,
  });

  /// The bounding box side length in logical pixels.
  final double size;

  /// The foreground colour of the dots.
  final Color color;

  @override
  State<SbProgressiveDots> createState() => _SbProgressiveDotsState();
}

class _SbProgressiveDotsState extends State<SbProgressiveDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final color = widget.color;

    /// Dot sizing (same ratio as original)
    final dotSize = size * 0.17;

    /// Strict spacing calculation (no overflow)
    final totalDotsWidth = 4 * dotSize;
    final gap = (size - totalDotsWidth) / 3;

    /// Movement distance (one step left)
    final step = dotSize + gap;

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final t = _controller.value;

          /// Helpers replacing `.eval()`
          double lerp(double a, double b, double t) => a + (b - a) * t;

          double interval(double t, double start, double end) {
            if (t <= start) return 0;
            if (t >= end) return 1;
            return (t - start) / (end - start);
          }

          /// Translation animation (matches original intervals)
          final translateT = interval(t, 0.22, 0.82);
          final dx = lerp(0, -step, translateT);

          /// First dot scaling out
          final scaleOut = 1 - interval(t, 0.0, 0.4);

          /// Last dot scaling in
          final scaleIn = interval(t, 0.3, 0.7);

          Widget dot() => Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              );

          Widget translatingDot() => Transform.translate(
                offset: Offset(dx, 0),
                child: dot(),
              );

          Widget scalingDot(double scale) => Transform.scale(
                scale: scale.clamp(0.0, 1.0),
                child: dot(),
              );

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// First dot (scale out)
              scalingDot(scaleOut),

              SizedBox(width: gap),

              /// Middle translating dots
              translatingDot(),

              SizedBox(width: gap),

              translatingDot(),

              SizedBox(width: gap),

              /// Last slot (stacked like original)
              Stack(
                alignment: Alignment.center,
                children: [
                  scalingDot(scaleIn),
                  translatingDot(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}