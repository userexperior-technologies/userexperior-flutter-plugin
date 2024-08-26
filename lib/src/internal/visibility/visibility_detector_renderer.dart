import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import 'visibility_detector__definitions.dart';

import 'visibility_detector_controller.dart';
import 'visibility_detector_snapshot.dart';

/// Based on the visibility_detector package, version: 0.4.0+2
///
mixin VisibilityDetectorRenderObject on RenderObject {
  // region - static - attributes
  static Map<Key, VoidCallback> _updates = <Key, VoidCallback>{};
  static Map<Key, VisibilitySnapshot> _lastVisibility =
      <Key, VisibilitySnapshot>{};

  // endregion
  // region - static - timer handler
  static Timer? _timer;

  static void _handleTimer() {
    _timer = null;
    // Ensure that work is done between frames so that calculations are
    // performed from a consistent state.  We use `scheduleTask<T>` here instead
    // of `addPostFrameCallback` or `scheduleFrameCallback` so that work will
    // be done even if a new frame isn't scheduled and without unnecessarily
    // scheduling a new frame.
    SchedulerBinding.instance.scheduleTask<void>(
      _processCallbacks,
      Priority.touch,
    );
  }

  /// Executes visibility callbacks for all updated instances.
  static void _processCallbacks() {

    for (final callback in _updates.values) {
      callback();
    }
    _updates.clear();
  }

  // endregion
  // region - static - methods
  /// See [VisibilityDetectorController.notifyNow].
  static void notifyNow() {
    _timer?.cancel();
    _timer = null;
    _processCallbacks();
  }

  static void forget(Key key) {
    _updates.remove(key);
    _lastVisibility.remove(key);

    if (_updates.isEmpty) {
      _timer?.cancel();
      _timer = null;
    }
  }

  // endregion

  // region - instance - attributes
  VoidCallback? _compositionCallbackCanceller;
  Matrix4? _lastPaintTransform;
  Rect? _lastPaintClipBounds;
  bool _disposed = false;

  // endregion

  // region - instance - on visibility changed
  /// private storage
  OnVisibilityChangedCallback? _onVisibilityChanged;

  /// See [VisibilityDetectorWidget.onVisibilityChanged].
  OnVisibilityChangedCallback? get onVisibilityChanged => _onVisibilityChanged;

  /// Used by [VisibilityDetectorWidget.updateRenderObject].
  set onVisibilityChanged(OnVisibilityChangedCallback? value) {
    if (_onVisibilityChanged == value) {
      return;
    }
    _compositionCallbackCanceller?.call();
    _compositionCallbackCanceller = null;
    _onVisibilityChanged = value;

    if (value == null) {
      // Remove all cached data so that we won't fire visibility callbacks when
      // a timer expires or get stale old information the next time around.
      forget(key);
    } else {
      markNeedsPaint();
      // If an update is happening and some ancestor no longer paints this RO,
      // the markNeedsPaint above will never cause the composition callback to
      // fire and we could miss a hide event. This schedule will get
      // over-written by subsequent updates in paint, if paint is called.
      _scheduleUpdate();
    }
  }

  // endregion

  // region - instance - overrides
  /// The key for the corresponding [VisibilityDetectorWidget] widget.
  Key get key;

  /// Used to get the bounds of the render object when it is time to update
  /// about visibility.
  ///
  /// A null value means bounds are not available.
  Rect? get bounds;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (onVisibilityChanged != null) {
      _lastPaintClipBounds = context.canvas.getLocalClipBounds();
      _lastPaintTransform =
          Matrix4.fromFloat64List(context.canvas.getTransform())
            ..translate(offset.dx, offset.dy, 0);

      _compositionCallbackCanceller?.call();
      _compositionCallbackCanceller =
          context.addCompositionCallback((Layer layer) {
        assert(!debugDisposed!);
        final ContainerLayer? container =
            layer is ContainerLayer ? layer : layer.parent;
        _scheduleUpdate(container);
      });
    }
    super.paint(context, offset);
  }

  @override
  void dispose() {
    _compositionCallbackCanceller?.call();
    _compositionCallbackCanceller = null;
    _disposed = true;
    super.dispose();
  }

  // endregion

  // region - instance - debug mode
  int _debugScheduleUpdateCount = 0;

  /// The number of times the schedule update callback has been invoked from
  /// [Layer.addCompositionCallback].
  ///
  /// This is used for testing, and always returns null outside of debug mode.
  @visibleForTesting
  int? get debugScheduleUpdateCount {
    if (kDebugMode) {
      return _debugScheduleUpdateCount;
    }
    return null;
  }

  // endregion

  // region - instance - helpers
  void _fireCallback(ContainerLayer? layer, Rect bounds) {
    final oldInfo = _lastVisibility[key];
    final info = _determineVisibility(layer, bounds);
    final visible = !info.visibleBounds.isEmpty;

    if (oldInfo == null) {
      if (!visible) {
        return;
      }
    } else if (info.matchesVisibility(oldInfo)) {
      return;
    }

    if (visible) {
      _lastVisibility[key] = info;
    } else {
      // Track only visible items so that the map does not grow unbounded.
      _lastVisibility.remove(key);
    }

    onVisibilityChanged?.call(info);
  }

  void _scheduleUpdate([ContainerLayer? layer]) {
    if (kDebugMode) {
      _debugScheduleUpdateCount += 1;
    }
    bool isFirstUpdate = _updates.isEmpty;
    _updates[key] = () {
      if (bounds == null) {
        // This can happen if set onVisibilityChanged was called with a non-null
        // value but this render object has not been laid out. In that case,
        // it has no size or geometry, and we should not worry about firing
        // an update since it never has been visible.
        return;
      }
      _fireCallback(layer, bounds!);
    };
    final updateInterval = VisibilityDetectorController.instance.updateInterval;
    if (updateInterval == Duration.zero) {
      // Even with [Duration.zero], we still want to defer callbacks to the end
      // of the frame so that they're processed from a consistent state.  This
      // also ensures that they don't mutate the widget tree while we're in the
      // middle of a frame.
      if (isFirstUpdate) {
        // We're about to render a frame, so a post-frame callback is guaranteed
        // to fire and will give us the better immediacy than `scheduleTask<T>`.
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          _processCallbacks();
        });
      }
    } else if (_timer == null) {
      // We use a normal [Timer] instead of a [RestartableTimer] so that changes
      // to the update duration will be picked up automatically.
      _timer = Timer(updateInterval, _handleTimer);
    } else {
      assert(_timer!.isActive);
    }
  }

  VisibilitySnapshot _determineVisibility(ContainerLayer? layer, Rect bounds) {
    if (_disposed || layer == null || layer.attached == false || !attached) {
      // layer is detached and thus invisible.
      return VisibilitySnapshot(
        key: key,
        size: _lastVisibility[key]?.size ?? Size.zero,
      );
    }

    final transform = Matrix4.identity();

    // Check if any ancestors decided to skip painting this RenderObject.
    if (parent != null) {
      // TODO(goderbauer): Remove ignore and cast when https://github.com/flutter/flutter/pull/128973 has reached stable.
      RenderObject ancestor =
      parent! as RenderObject; // ignore: unnecessary_cast
      RenderObject child = this;
      while (ancestor.parent != null) {
        if (!ancestor.paintsChild(child)) {
          return VisibilitySnapshot(key: key, size: bounds.size);
        }
        child = ancestor;
        // TODO(goderbauer): Remove ignore and cast when https://github.com/flutter/flutter/pull/128973 has reached stable.
        ancestor = ancestor.parent! as RenderObject; // ignore: unnecessary_cast
      }
    }


    // Create a list of Layers from layer to the root, excluding the root
    // since that has the DPR transform and we want to work with logical pixels.
    // Add one extra leaf layer so that we can apply the transform of `layer`
    // to the matrix.
    ContainerLayer? ancestor = layer;
    final List<ContainerLayer> ancestors = <ContainerLayer>[ContainerLayer()];
    while (ancestor != null && ancestor.parent != null) {
      ancestors.add(ancestor);
      ancestor = ancestor.parent;
    }

    Rect clip = Rect.largest;
    for (int index = ancestors.length - 1; index > 0; index -= 1) {
      final parent = ancestors[index];
      final child = ancestors[index - 1];
      Rect? parentClip = parent.describeClipBounds();
      if (parentClip != null) {
        clip = clip.intersect(MatrixUtils.transformRect(transform, parentClip));
      }
      parent.applyTransform(child, transform);
    }

    // Apply whatever transform/clip was on the canvas when painting.
    if (_lastPaintClipBounds != null) {
      clip = clip.intersect(MatrixUtils.transformRect(
        transform,
        _lastPaintClipBounds!,
      ));
    }
    if (_lastPaintTransform != null) {
      transform.multiply(_lastPaintTransform!);
    }

    return VisibilitySnapshot.fromRectangles(
      key: key,
      widgetBounds: MatrixUtils.transformRect(transform, bounds),
      clipRect: clip,
    );
  }
// endregion
}

/// The [RenderObject] corresponding to the [VisibilityDetectorWidget] widget.
class VisibilityDetectorRender extends RenderProxyBox
    with VisibilityDetectorRenderObject {
  // region - constructors
  /// Constructor.  See the corresponding properties for parameter details.
  VisibilityDetectorRender({
    required this.key,
    RenderBox? child,
    required OnVisibilityChangedCallback? onVisibilityChanged,
  }) : super(child) {
    _onVisibilityChanged = onVisibilityChanged;
  }

  // endregion

  // region - override
  @override
  final Key key;

  @override
  Rect? get bounds => hasSize ? semanticBounds : null;
// endregion
}
