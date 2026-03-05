import 'package:flutter/rendering.dart';

/// Draws a circle outline that animates in, followed by an animated cross (✗).
///
/// [progress] drives both sub-animations (range 0.0 → 1.0):
///   • 0.0 – 0.4 → the circle arc closes
///   • 0.4 – 0.7 → the first diagonal line is drawn (↘)
///   • 0.7 – 1.0 → the second diagonal line is drawn (↙)
///
/// [color] is applied to every stroke – typically white or a contrasting hue.
class SbCrossPainter extends CustomPainter {
  /// Creates a cross painter.
  ///
  /// [progress] must be in [0, 1].
  const SbCrossPainter({required this.progress, required this.color});

  /// Animation progress supplied by an [AnimationController]. Range 0 – 1.
  final double progress;

  /// Stroke colour for both the circle and cross lines.
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // ── Circle arc ────────────────────────────────────────────────────────
    final circleT = (progress * 1.4).clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromLTWH(
        p.strokeWidth / 2,
        p.strokeWidth / 2,
        size.width - p.strokeWidth,
        size.height - p.strokeWidth,
      ),
      -1.5708,
      circleT * 6.2832,
      false,
      p,
    );

    // ── Cross strokes ─────────────────────────────────────────────────────
    if (progress <= 0.4) return;

    final crossT = ((progress - 0.4) / 0.6).clamp(0.0, 1.0);
    final pad = size.width * 0.27;

    // Line 1: top-left → bottom-right
    final t1 = (crossT * 2).clamp(0.0, 1.0);
    final tl = Offset(pad, pad);
    final br = Offset(size.width - pad, size.height - pad);
    canvas.drawLine(tl, Offset.lerp(tl, br, t1)!, p);

    // Line 2: top-right → bottom-left (starts halfway through the animation)
    if (crossT <= 0.5) return;
    final t2 = ((crossT - 0.5) * 2).clamp(0.0, 1.0);
    final tr = Offset(size.width - pad, pad);
    final bl = Offset(pad, size.height - pad);
    canvas.drawLine(tr, Offset.lerp(tr, bl, t2)!, p);
  }

  @override
  bool shouldRepaint(SbCrossPainter old) => old.progress != progress;
}
