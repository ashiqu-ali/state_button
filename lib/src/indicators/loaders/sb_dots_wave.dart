import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Three dots moving in a smooth sine-based wave using phase-shifted
/// animation.
///
/// A single [AnimationController] drives all three dots. Each dot's vertical
/// position is derived by offsetting the shared controller value by
/// `i × 0.2` in the 0–1 cycle and mapping it through a sine curve,
/// producing a continuous flowing wave motion.
class SbDotsWave extends StatefulWidget {
  /// Creates a dots-wave loader with the given [size] and [color].
  const SbDotsWave({
    super.key,
    required this.size,
    required this.color,
  });

  /// The bounding box side length in logical pixels. Must be greater than zero.
  final double size;

  /// The foreground colour of the dots.
  final Color color;

  @override
  State<SbDotsWave> createState() => _SbDotsWaveState();
}

class _SbDotsWaveState extends State<SbDotsWave>
    with SingleTickerProviderStateMixin {
  static const int _kDotCount = 3;

  // Phase offset between each dot (0.0–1.0 fraction of the full cycle).
  static const double _kPhaseStep = 0.2;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Base dot size relative to the available bounding box.
    final dotSize = widget.size * 0.22;

    // Spacing between dots.
    final spacing = dotSize * 0.5;

    // Total width = dots + spaces between them (NOT per-dot margins).
    final totalWidth =
        (_kDotCount * dotSize) + ((_kDotCount - 1) * spacing);

    // Scale down only if necessary (guards against subpixel overflow).
    final scaleFactor =
        totalWidth > widget.size ? widget.size / totalWidth : 1.0;

    // Maximum vertical displacement for the wave motion.
    final maxOffset = widget.size * 0.15;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Center(
        child: Transform.scale(
          scale: scaleFactor,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(_kDotCount, (i) {
                  // Shift each dot's position in the 0–1 cycle by its index offset,
                  // then wrap with modulo so the value stays in [0, 1).
                  final phase =
                      (_controller.value + i * _kPhaseStep) % 1.0;

                  // Map phase through a full sine wave (-1 to 1) for smooth motion.
                  final y = math.sin(phase * 2 * math.pi);

                  return Padding(
                    // Apply spacing only between dots (not on both sides).
                    padding: EdgeInsets.only(
                      right: i == _kDotCount - 1 ? 0 : spacing,
                    ),
                    child: Transform.translate(
                      // Move the dot vertically to create the wave effect.
                      offset: Offset(0, -y * maxOffset),
                      child: Container(
                        width: dotSize,
                        height: dotSize,
                        decoration: BoxDecoration(
                          color: widget.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}