import 'package:flutter/material.dart';

/// Three dots that uniformly scale up and down with a delayed start
/// (pulse effect).
///
/// Each dot has its own [AnimationController] started with a fixed delay.
/// Both the size and opacity of each dot are driven by the controller value,
/// creating a pulsing in-and-out rhythm. Sizing is overflow-safe: at peak
/// scale the total Row width is always ≤ [size].
class SbDotsPulse extends StatefulWidget {
  /// Creates a dots-pulse loader with the given [size] and [color].
  const SbDotsPulse({
    super.key,
    required this.size,
    required this.color,
  });

  /// The bounding box side length in logical pixels. Must be greater than zero.
  final double size;

  /// The foreground colour of the dots.
  ///
  /// Also used at reduced opacity during the pulse trough via [Color.withValues].
  final Color color;

  @override
  State<SbDotsPulse> createState() => _SbDotsPulseState();
}

class _SbDotsPulseState extends State<SbDotsPulse>
    with TickerProviderStateMixin {
  static const int _kDotCount = 3;
  static const Duration _kPeriod = Duration(milliseconds: 700);
  static const Duration _kStagger = Duration(milliseconds: 180);

  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _kDotCount,
      (_) => AnimationController(vsync: this, duration: _kPeriod),
    );
    for (int i = 0; i < _kDotCount; i++) {
      Future.delayed(_kStagger * i, () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Derive dotSize so that 3 fully-scaled dots + their margins always fit
    // within `size`. Each dot occupies (dotSize * scale) width plus
    // (dotSize * 0.18 * 2) horizontal margin. At peak scale = 1.0:
    //   totalWidth = 3 * dotSize * (1 + 0.36) = 3 * dotSize * 1.36
    // Solving for dotSize: dotSize = size / (3 * 1.36) ≈ size * 0.245.
    // A small safety factor (0.24) absorbs subpixel rounding at all densities.
    final dotSize = widget.size * 0.24;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_kDotCount, (i) {
          return AnimatedBuilder(
            animation: _controllers[i],
            builder: (_, __) {
              final v = _controllers[i].value;
              final scale = 0.55 + v * 0.45;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: dotSize * 0.18),
                width: dotSize * scale,
                height: dotSize * scale,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.35 + v * 0.65),
                  shape: BoxShape.circle,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
