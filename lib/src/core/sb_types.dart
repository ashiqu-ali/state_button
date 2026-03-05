// ignore_for_file: library_private_types_in_public_api

/// Represents the four mutually-exclusive visual phases a [StateButton] can be in.
///
/// - [idle]    → default, tap-able state
/// - [loading] → shows a spinner; taps are disabled
/// - [success] → shows an animated tick in a circle; auto-resets to [idle]
/// - [failure] → shows an animated cross in a circle; auto-resets to [idle]
enum SbPhase {
  /// The button is ready and accepts taps.
  idle,

  /// An async operation is in progress; taps are suppressed.
  loading,

  /// The operation completed successfully; an animated ✓ is drawn.
  success,

  /// The operation failed; an animated ✗ is drawn.
  failure,
}
