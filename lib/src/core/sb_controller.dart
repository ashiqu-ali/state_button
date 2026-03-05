import 'package:flutter/foundation.dart';

import 'package:state_button/src/core/sb_types.dart';

/// Drives the visual state of a [StateButton].
///
/// Obtain one instance per button, keep it alive (e.g. inside a `StatefulWidget`
/// or a provider), and call the convenience setters to transition phases:
///
/// ```dart
/// final _ctrl = SbController();
///
/// Future<void> _submit() async {
///   _ctrl.setLoading();
///   try {
///     await myApi.save();
///     _ctrl.setSuccess();
///   } catch (_) {
///     _ctrl.setFailure();
///   }
/// }
/// ```
///
/// Remember to call [dispose] when the controller is no longer needed.
class SbController {
  /// Internal listenable that the button widget observes.
  final ValueNotifier<SbPhase> _$phase = ValueNotifier(SbPhase.idle);

  /// Exposes the [ValueNotifier] so [StateButton] can rebuild on change.
  ///
  /// You rarely need to access this directly from outside the package.
  @internal
  ValueNotifier<SbPhase> get $notifier => _$phase;

  /// The currently active phase.
  SbPhase get phase => _$phase.value;

  // ── Transition helpers ────────────────────────────────────────────────────

  /// Resets the button to its default tap-able state.
  void setIdle() => _$phase.value = SbPhase.idle;

  /// Shows a spinner and disables taps until another setter is called.
  void setLoading() => _$phase.value = SbPhase.loading;

  /// Shows an animated success tick.  Auto-resets to [idle] after
  /// [StateButton.autoResetDuration].
  void setSuccess() => _$phase.value = SbPhase.success;

  /// Shows an animated failure cross.  Auto-resets to [idle] after
  /// [StateButton.autoResetDuration].
  void setFailure() => _$phase.value = SbPhase.failure;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  /// Releases the underlying [ValueNotifier].
  ///
  /// Always call this in `dispose()` of the parent widget.
  void dispose() => _$phase.dispose();
}
