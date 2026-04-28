import 'package:flutter/widgets.dart';

import '../core/sb_loader_type.dart';
import 'index.dart';

/// Routes the correct loading widget for the given [SbLoaderType].
///
/// Acts as a factory / router only — all animation logic lives in the
/// individual loader files under `loaders/`.
class SbLoadingIndicator extends StatelessWidget {
  /// Creates a loading indicator for the given [SbLoaderType].
  const SbLoadingIndicator({
    super.key,
    required this.type,
    required this.color,
    required this.size,
  });

  /// The style of loading animation to render. See [SbLoaderType] for options.
  final SbLoaderType type;

  /// The foreground colour applied to the indicator.
  ///
  /// For [SbLoaderType.dotsPulse] this colour is also used at reduced opacity
  /// during the pulse trough.
  final Color color;

  /// The bounding box side length in logical pixels.
  ///
  /// Both width and height are set to this value. Must be greater than zero.
  final double size;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SbLoaderType.cupertinoSpinner:
        return SbCupertinoSpinner(size: size, color: color);

      case SbLoaderType.circular:
        return SbCircularLoader(size: size, color: color);

      case SbLoaderType.dotsWave:
        return SbDotsWave(size: size, color: color);

      case SbLoaderType.dotsPulse:
        return SbDotsPulse(size: size, color: color);

      case SbLoaderType.progressiveDots:
        return SbProgressiveDots(size: size, color: color);

      case SbLoaderType.spinningArc:
        return SbSpinningArc(size: size, color: color);
    }
  }
}