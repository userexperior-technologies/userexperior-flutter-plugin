import 'package:flutter/widgets.dart';
import 'visibility_detector__definitions.dart';
import 'visibility_detector_renderer.dart';

/// Based on the visibility_detector package, version: 0.4.0+2
///
/// A [VisibilityDetectorWidget] fires a specified callback when the widget
/// visibility change.
///
/// Callbacks are not fired immediately on visibility changes.
///
/// Instead, callbacks are deferred and coalesced such that the callback for
/// each [VisibilityDetectorWidget] will be invoked at most once per
/// [DetectorController.updateInterval] (unless forced by
/// [DetectorController.notifyNow]).  Callbacks for *all*
///
/// [VisibilityDetectorWidget] widgets are fired together synchronously between
/// frames.
class VisibilityDetectorWidget extends SingleChildRenderObjectWidget {
  // region - attributes
  /// A callback to invoke when this widget's visibility changes.
  final OnVisibilityChangedCallback? onVisibilityChanged;

  // endregion

  // region - constructor
  /// Constructor.
  ///
  /// `key` is required to properly identify this widget; it must be unique
  /// among all [VisibilityDetectorWidget] widgets.
  ///
  /// `onVisibilityChanged` may be `null` to disable this [VisibilityDetector].
  const VisibilityDetectorWidget({
    required Key key,
    required Widget child,
    required this.onVisibilityChanged,
  }) : super(key: key, child: child);

  // endregion

  // region - override
  @override
  RenderObject createRenderObject(BuildContext context) {
    return VisibilityDetectorRender(
      key: key!,
      onVisibilityChanged: onVisibilityChanged,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, VisibilityDetectorRender renderObject) {
    assert(renderObject.key == key);
    renderObject.onVisibilityChanged = onVisibilityChanged;
  }
// endregion
}
