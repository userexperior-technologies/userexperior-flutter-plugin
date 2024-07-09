import 'visibility_detector_controller.dart';
import 'visibility_detector_snapshot.dart';

/// Based on the visibility_detector package, version: 0.4.0+2
///

/// Signature of callbacks that has a single [VisibilitySnapshot] input argument
/// and returns no data.
typedef OnVisibilityChangedCallback = void Function(VisibilitySnapshot info);

typedef DefaultDetectorController = VisibilityDetectorController;
