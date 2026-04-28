import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A single arc that continuously rotates with a rounded stroke cap.
///
/// Uses a [CustomPainter] ([_ArcPainter]) driven by one [AnimationController]
/// to draw an arc that sweeps ~220° and rotates a full 360° per cycle.
class SbSpinningArc extends StatefulWidget {
  /// Creates a spinning-arc loader with the given [size] and [color].
  const SbSpinningArc({
    super.key,
    required this.size,
    required this.color,
  });

  /// The bounding box side length in logical pixels. Must be greater than zero.
  final double size;

  /// The stroke colour of the arc.
  final Color color;

  @override
  State<SbSpinningArc> createState() => _SbSpinningArcState();
}

class _SbSpinningArcState extends State<SbSpinningArc>
    with SingleTickerProviderStateMixin {
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _ArcPainter(
          progress: _controller.value,
          color: widget.color,
          strokeWidth: widget.size * 0.1,
        ),
      ),
    );
  }
}

/// [CustomPainter] that draws the rotating arc for [SbSpinningArc].
class _ArcPainter extends CustomPainter {
  const _ArcPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Offset.zero & size;
    // Rotate full circle, sweep a fixed arc of ~220°
    canvas.drawArc(
      rect,
      progress * math.pi * 2,
      math.pi * 1.2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.progress != progress || old.color != color;
}
