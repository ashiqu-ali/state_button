import 'package:flutter/rendering.dart';

/// Draws a circle outline that animates in, followed by an animated tick (✓).
///
/// [progress] drives both sub-animations (range 0.0 → 1.0):
///   • 0.0 – 0.5 → the circle arc closes
///   • 0.5 – 1.0 → the tick stroke is drawn
///
/// [color] is applied to every stroke – typically white or a contrasting hue.
class SbTickPainter extends CustomPainter {
  /// Creates a tick painter.
  ///
  /// [progress] must be in [0, 1].
  const SbTickPainter({required this.progress, required this.color});

  /// Animation progress supplied by an [AnimationController]. Range 0 – 1.
  final double progress;

  /// Stroke colour for both the circle and tick lines.
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
    final arcRect = Rect.fromLTWH(
      p.strokeWidth / 2,
      p.strokeWidth / 2,
      size.width - p.strokeWidth,
      size.height - p.strokeWidth,
    );
    canvas.drawArc(arcRect, -1.5708, circleT * 6.2832, false, p);

    // ── Tick stroke ───────────────────────────────────────────────────────
    if (progress <= 0.5) return;

    final tickT = ((progress - 0.5) / 0.5).clamp(0.0, 1.0);
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Three key-points that define the ✓ shape.
    final a = Offset(cx - size.width * 0.22, cy);
    final b = Offset(cx - size.width * 0.04, cy + size.height * 0.18);
    final c = Offset(cx + size.width * 0.25, cy - size.height * 0.15);

    final path = Path()..moveTo(a.dx, a.dy);

    if (tickT < 0.5) {
      final mid = Offset.lerp(a, b, tickT * 2)!;
      path.lineTo(mid.dx, mid.dy);
    } else {
      final end = Offset.lerp(b, c, (tickT - 0.5) * 2)!;
      path
        ..lineTo(b.dx, b.dy)
        ..lineTo(end.dx, end.dy);
    }

    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(SbTickPainter old) => old.progress != progress;
}
