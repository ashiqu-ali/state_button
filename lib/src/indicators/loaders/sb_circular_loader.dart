import 'package:flutter/material.dart';

/// Material-style circular progress indicator.
///
/// Wraps [CircularProgressIndicator] and constrains it to [size] × [size]
/// so it fits consistently alongside the other loader variants.
class SbCircularLoader extends StatelessWidget {
  /// Creates a circular loader with the given [size] and [color].
  const SbCircularLoader({
    super.key,
    required this.size,
    required this.color,
  });

  /// The bounding box side length in logical pixels. Must be greater than zero.
  final double size;

  /// The stroke colour of the circular indicator.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: size * 0.1,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
