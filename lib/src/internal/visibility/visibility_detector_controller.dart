import 'package:flutter/foundation.dart';

import 'visibility_detector_renderer.dart';

/// Based on the visibility_detector package, version: 0.4.0+2
///
class VisibilityDetectorController {
  // region - attributes
  /// The minimum amount of time to wait between firing batches of visibility
  /// callbacks.
  ///
  /// If set to [Duration.zero], callbacks instead will fire at the end of every
  /// frame.  This is useful for automated tests.
  ///
  /// Changing [updateInterval] will not affect any pending callbacks.  Clients
  /// should call [notifyNow] explicitly to flush them if desired.
  Duration updateInterval = const Duration(milliseconds: 500);

  // endregion
  // region - singleton
  static VisibilityDetectorController _instance =
      VisibilityDetectorController();

  /// The default instance of [DetectorController] to use.
  ///
  /// Defaults to [DefaultDetectorController].
  static VisibilityDetectorController get instance => _instance;

  /// Subclasses implementations should set this with their own
  /// Subclass that extends [VisibilityDetectorController] when they register themselves.
  static set instance(VisibilityDetectorController instance) => _instance = instance;
// endregion

// region - override methods
  /// Forces firing all pending visibility callbacks immediately.
  ///
  /// This might be desirable just prior to tearing down the widget tree (such
  /// as when switching views or when exiting the application).
  void notifyNow() => VisibilityDetectorRenderObject.notifyNow();

  /// Forgets any pending visibility callbacks for the [VisibilityDetector] with
  /// the given [key].
  ///
  /// If the widget gets attached/detached, the callback will be rescheduled.
  ///
  /// This method can be used to cancel timers after the [VisibilityDetector]
  /// has been detached to avoid pending timers in tests.
  void forget(Key key) => VisibilityDetectorRenderObject.forget(key);
// endregion
}
