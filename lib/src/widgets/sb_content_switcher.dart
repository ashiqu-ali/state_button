import 'package:flutter/cupertino.dart';

import '../core/sb_types.dart';
import '../indicators/sb_failure_indicator.dart';
import '../indicators/sb_success_indicator.dart';

/// Internal widget that switches between the four content states using
/// [AnimatedSwitcher].  Not part of the public API.
///
/// The switcher uses a combined scale + fade transition so the outgoing child
/// shrinks away while the incoming child grows in.
class SbContentSwitcher extends StatelessWidget {
  /// Creates the internal content switcher.
  const SbContentSwitcher({
    super.key,
    required this.phase,
    required this.idleChild,
    required this.indicatorSize,
    required this.loadingColor,
    required this.successIconColor,
    required this.failureIconColor,
    required this.animationDuration,
    required this.autoResetDuration,
    required this.onAutoReset,
  });

  /// Current [SbPhase] coming from [SbController].
  final SbPhase phase;

  /// The widget shown when phase is [SbPhase.idle] – usually a [Text] label.
  final Widget idleChild;

  /// Diameter in logical pixels for the spinner, success, and failure icons.
  final double indicatorSize;

  /// Colour of the [CupertinoActivityIndicator] during [SbPhase.loading].
  final Color loadingColor;

  /// Stroke colour for the success tick and its circle outline.
  final Color successIconColor;

  /// Stroke colour for the failure cross and its circle outline.
  final Color failureIconColor;

  /// Duration for the [AnimatedSwitcher] transition between phases.
  final Duration animationDuration;

  /// Time before success / failure indicators auto-return to idle.
  final Duration autoResetDuration;

  /// Forwarded to [SbSuccessIndicator] and [SbFailureIndicator] so they can
  /// call [SbController.setIdle] after displaying.
  final VoidCallback onAutoReset;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: animationDuration,
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: _resolve(),
    );
  }

  Widget _resolve() {
    switch (phase) {
      case SbPhase.idle:
        return KeyedSubtree(key: const ValueKey('sb_idle'), child: idleChild);

      case SbPhase.loading:
        return KeyedSubtree(
          key: const ValueKey('sb_loading'),
          child: CupertinoActivityIndicator(
            color: loadingColor,
            radius: indicatorSize / 2,
          ),
        );

      case SbPhase.success:
        return SbSuccessIndicator(
          key: const ValueKey('sb_success'),
          size: indicatorSize,
          iconColor: successIconColor,
          autoResetDuration: autoResetDuration,
          onComplete: onAutoReset,
        );

      case SbPhase.failure:
        return SbFailureIndicator(
          key: const ValueKey('sb_failure'),
          size: indicatorSize,
          iconColor: failureIconColor,
          autoResetDuration: autoResetDuration,
          onComplete: onAutoReset,
        );
    }
  }
}
