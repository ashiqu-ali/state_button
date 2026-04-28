import 'package:flutter/cupertino.dart';

/// iOS-style spinner using [CupertinoActivityIndicator].
///
/// Renders the native Cupertino spinning-ticks indicator scaled to [size].
class SbCupertinoSpinner extends StatelessWidget {
  /// Creates a Cupertino spinner with the given [size] and [color].
  const SbCupertinoSpinner({
    super.key,
    required this.size,
    required this.color,
  });

  /// The bounding box side length in logical pixels. Must be greater than zero.
  final double size;

  /// The foreground colour of the spinning ticks.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      color: color,
      radius: size / 2,
    );
  }
}
