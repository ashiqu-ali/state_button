/// The style of loading indicator shown inside a [StateButton] while it is in
/// [SbPhase.loading].
///
/// Pass the desired value to `StateButton.loaderType`. Defaults to
/// [SbLoaderType.cupertinoSpinner] when not specified.
///
/// Example:
/// ```dart
/// StateButton(
///   controller: _controller,
///   loaderType: SbLoaderType.spinningArc,
///   child: const Text('Submit'),
/// )
/// ```
///
/// See also:
/// - [SbPhase], which controls when the indicator is visible.
/// - [SbLoadingIndicator], the widget that renders each loader variant.
enum SbLoaderType {
  /// An iOS-style spinner using [CupertinoActivityIndicator].
  ///
  /// This is the default loader and preserves the original behaviour
  /// of the package for backward compatibility.
  cupertinoSpinner,

  /// A circular progress indicator based on
  /// [CircularProgressIndicator].
  ///
  /// Displays a continuously rotating full-circle stroke.
  circular,

  /// Three dots moving in a smooth sine-based wave pattern.
  ///
  /// Each dot is vertically translated using a phase-shifted animation,
  /// creating a continuous flowing wave effect.
  dotsWave,

  /// Three dots that pulse by scaling in and out sequentially.
  ///
  /// Creates a rhythmic "breathing" animation effect.
  dotsPulse,

  /// Four dots that move progressively from right to left.
  ///
  /// The leading dot fades out while a new dot appears at the end,
  /// creating a continuous "typing" or loading motion.
  progressiveDots,

  /// A custom rotating arc with a rounded stroke cap.
  ///
  /// Unlike [circular], this renders only a partial arc that spins,
  /// giving a more modern and minimal appearance.
  spinningArc,
}