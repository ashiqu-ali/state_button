import 'package:flutter/widgets.dart';

import '../painters/sb_cross_painter.dart';

/// Animated ✗-in-circle indicator shown when [SbPhase.failure] is active.
///
/// Drives its own [AnimationController] – the parent does not need to manage it.
/// After [autoResetDuration] the [onComplete] callback is invoked so
/// [SbController] can return to [SbPhase.idle].
class SbFailureIndicator extends StatefulWidget {
  /// Creates a failure indicator.
  const SbFailureIndicator({
    super.key,
    required this.size,
    required this.iconColor,
    required this.autoResetDuration,
    required this.onComplete,
  });

  /// Diameter of the drawn circle (and bounding box of the canvas).
  final double size;

  /// Colour applied to both the circle stroke and the cross strokes.
  final Color iconColor;

  /// How long to wait after the draw animation completes before calling
  /// [onComplete].  Typically set to [StateButton.autoResetDuration].
  final Duration autoResetDuration;

  /// Called once, after [autoResetDuration], to reset the button to idle.
  final VoidCallback onComplete;

  @override
  State<SbFailureIndicator> createState() => _SbFailureIndicatorState();
}

class _SbFailureIndicatorState extends State<SbFailureIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();

    Future.delayed(widget.autoResetDuration, () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => CustomPaint(
          painter: SbCrossPainter(
            progress: _anim.value,
            color: widget.iconColor,
          ),
        ),
      ),
    );
  }
}
