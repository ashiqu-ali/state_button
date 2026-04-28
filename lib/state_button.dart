/// A lightweight Flutter package that provides an animated button capable of
/// expressing four visual states: idle, loading, success, and failure.
///
/// ## Quick start
///
/// ```dart
/// import 'package:state_button/state_button.dart';
///
/// final _ctrl = SbController();
///
/// StateButton(
///   controller: _ctrl,
///   onPressed: () async {
///     _ctrl.setLoading();
///     await Future.delayed(const Duration(seconds: 2));
///     _ctrl.setSuccess();   // or _ctrl.setFailure();
///   },
/// )
/// ```
///
/// ## Public API
///
/// | Symbol           | Description                                           |
/// |------------------|-------------------------------------------------------|
/// | [StateButton]    | The button widget                                     |
/// | [SbController]   | Drives the button's phase transitions                 |
/// | [SbPhase]        | Enum of the four phases (idle / loading / success / failure) |
library state_button;

export 'src/core/sb_controller.dart';
export 'src/core/sb_loader_type.dart';
export 'src/core/sb_types.dart';
export 'src/widgets/state_button.dart';
