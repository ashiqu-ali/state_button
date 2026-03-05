import 'package:flutter/material.dart';

import '../core/sb_controller.dart';
import '../core/sb_types.dart';
import 'sb_content_switcher.dart';

/// A fully-animated button that transitions through four visual phases:
/// idle → loading → success / failure → (auto-reset) → idle.
///
/// ### Minimal usage
/// ```dart
/// final _ctrl = SbController();
///
/// @override
/// void dispose() {
///   _ctrl.dispose();
///   super.dispose();
/// }
///
/// StateButton(
///   controller: _ctrl,
///   onPressed: () async {
///     _ctrl.setLoading();
///     await Future.delayed(const Duration(seconds: 2));
///     _ctrl.setSuccess();
///   },
/// )
/// ```
///
/// ### Customisation
/// Every visual detail – colours, size, radius, shadow, durations – is
/// configurable via named parameters.  Pass a [BoxDecoration] to [decoration]
/// for complete control over the container's appearance.
class StateButton extends StatelessWidget {
  /// Creates a [StateButton].
  ///
  /// [controller] and [onPressed] are required; all other parameters have
  /// sensible defaults.
  const StateButton({
    super.key,
    required this.controller,
    required this.onPressed,
    // ── Content ────────────────────────────────────────────────────────────
    this.child = const Text('Submit', style: TextStyle(color: Colors.white)),
    // ── Dimensions ─────────────────────────────────────────────────────────
    this.width,
    this.height = 52,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 12,
    // ── Colours ────────────────────────────────────────────────────────────
    this.backgroundColor = const Color(0xFF6366F1),
    this.splashColor,
    this.highlightColor,
    this.successColor = const Color(0xFF22C55E),
    this.failureColor = const Color(0xFFEF4444),
    // ── Decoration override ────────────────────────────────────────────────
    this.decoration,
    this.boxShadow,
    // ── Indicator ─────────────────────────────────────────────────────────
    this.indicatorSize = 26,
    this.loadingColor = Colors.white,
    this.successIconColor = Colors.white,
    this.failureIconColor = Colors.white,
    // ── Timing ────────────────────────────────────────────────────────────
    this.autoResetDuration = const Duration(milliseconds: 1800),
    this.animationDuration = const Duration(milliseconds: 300),
  });

  // ── Required ──────────────────────────────────────────────────────────────

  /// Drives the button's phase transitions.  Create one per button and call
  /// [SbController.setLoading], [SbController.setSuccess], etc. from your
  /// business logic.
  final SbController controller;

  /// Called when the button is tapped while in [SbPhase.idle].
  ///
  /// Taps are ignored in every other phase – no need to guard against
  /// double-submission.
  final VoidCallback onPressed;

  // ── Content ───────────────────────────────────────────────────────────────

  /// The widget displayed in [SbPhase.idle].
  ///
  /// Typically a [Text] but can be any widget (icon + label row, etc.).
  /// Defaults to `Text('Submit')`.
  final Widget child;

  // ── Dimensions ────────────────────────────────────────────────────────────

  /// Fixed width of the button.  When `null` the button stretches to fill
  /// its parent (standard [BoxConstraints] apply).
  final double? width;

  /// Fixed height of the button in logical pixels.  Defaults to `52`.
  final double height;

  /// Inner padding between the button edge and [child] / indicator.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 24, vertical: 12)`.
  final EdgeInsetsGeometry padding;

  /// Outer margin around the entire button widget.
  final EdgeInsetsGeometry margin;

  /// Corner radius of the button's rounded rectangle.  Defaults to `12`.
  final double borderRadius;

  // ── Colours ───────────────────────────────────────────────────────────────

  /// Fill colour for the [SbPhase.idle] state.  Defaults to indigo `#6366F1`.
  final Color backgroundColor;

  /// Ink splash colour on tap.  Defaults to semi-transparent white.
  final Color? splashColor;

  /// Ink highlight colour on long-press.  Defaults to semi-transparent white.
  final Color? highlightColor;

  /// Fill colour that fades in during [SbPhase.success].
  /// Defaults to green `#22C55E`.
  final Color successColor;

  /// Fill colour that fades in during [SbPhase.failure].
  /// Defaults to red `#EF4444`.
  final Color failureColor;

  // ── Decoration ────────────────────────────────────────────────────────────

  /// Fully overrides the button's [BoxDecoration] when provided.
  ///
  /// When set, [backgroundColor], [borderRadius], and [boxShadow] are
  /// **ignored** unless you include them in the [BoxDecoration] yourself.
  /// The animated fill colour is still injected via `copyWith`.
  final BoxDecoration? decoration;

  /// Drop-shadow list applied to the button container.
  ///
  /// Has no effect when [decoration] is provided.
  final List<BoxShadow>? boxShadow;

  // ── Indicator ─────────────────────────────────────────────────────────────

  /// Diameter of the spinner / success-tick / failure-cross in logical pixels.
  /// Defaults to `26`.
  final double indicatorSize;

  /// Colour of the [CupertinoActivityIndicator] in [SbPhase.loading].
  final Color loadingColor;

  /// Stroke colour for the success ✓ and circle outline. Defaults to white.
  final Color successIconColor;

  /// Stroke colour for the failure ✗ and circle outline. Defaults to white.
  final Color failureIconColor;

  // ── Timing ────────────────────────────────────────────────────────────────

  /// How long the success / failure indicator stays visible before the button
  /// automatically resets to [SbPhase.idle].  Defaults to `1 800 ms`.
  final Duration autoResetDuration;

  /// Duration of the [AnimatedContainer] colour transition and the
  /// [AnimatedSwitcher] content crossfade.  Defaults to `300 ms`.
  final Duration animationDuration;

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SbPhase>(
      valueListenable: controller.$notifier,
      builder: (context, phase, _) {
        // Resolve fill colour based on current phase.
        final Color fill = switch (phase) {
          SbPhase.success => successColor,
          SbPhase.failure => failureColor,
          _ => backgroundColor,
        };

        final radius = BorderRadius.circular(borderRadius);

        return AnimatedContainer(
          duration: animationDuration,
          margin: margin,
          width: width,
          height: height,
          decoration: decoration?.copyWith(color: decoration?.color ?? fill) ??
              BoxDecoration(
                color: fill,
                borderRadius: radius,
                boxShadow: boxShadow,
              ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: radius,
              // Taps are silently blocked in every non-idle phase.
              onTap: phase == SbPhase.idle ? onPressed : null,
              splashColor: splashColor ?? Colors.white.withValues(alpha: 0.15),
              highlightColor:
                  highlightColor ?? Colors.white.withValues(alpha: 0.08),
              child: Padding(
                padding: padding,
                child: Center(
                  child: SbContentSwitcher(
                    phase: phase,
                    idleChild: child,
                    indicatorSize: indicatorSize,
                    loadingColor: loadingColor,
                    successIconColor: successIconColor,
                    failureIconColor: failureIconColor,
                    animationDuration: animationDuration,
                    autoResetDuration: autoResetDuration,
                    onAutoReset: controller.setIdle,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
