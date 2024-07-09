import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

/// Based on the visibility_detector package, version: 0.4.0+2
///
/// Data passed to the [VisibilityDetector.onVisibilityChanged] callback.
@immutable
class VisibilitySnapshot {
  // region - static attributes
  /// The tolerance used to determine whether two floating-point values are
  /// approximately equal.
  static const _defaultTolerance = 0.01;

  // endregion

  // region - attributes
  /// The key for the corresponding [VisibilityDetector] widget.
  final Key key;

  /// The size of the widget the [VisibilitySnapshot] is associated with.
  final Size size;

  /// The visible portion of the widget, in the widget's local coordinates.
  ///
  /// The bounds are reported using the widget's local coordinates to avoid
  /// expectations for the [OnVisibilityChangedCallback] to fire if the widget's
  /// position changes but retains the same visibility.
  final Rect visibleBounds;

  // endregion

  // region - getters
  /// A fraction in the range \[0, 1\] that represents what proportion of the
  /// widget is visible (assuming rectangular bounding boxes).
  ///
  /// 0 means not visible; 1 means fully visible.
  double get visibleFraction {
    final visibleArea = _area(visibleBounds.size);
    final maxVisibleArea = _area(size);

    if (_floatNear(maxVisibleArea, 0)) {
      // Avoid division-by-zero.
      return 0;
    }

    var visibleFraction = visibleArea / maxVisibleArea;

    if (_floatNear(visibleFraction, 0)) {
      visibleFraction = 0;
    } else if (_floatNear(visibleFraction, 1)) {
      // The inexact nature of floating-point arithmetic means that sometimes
      // the visible area might never equal the maximum area (or could even
      // be slightly larger than the maximum).  Snap to the maximum.
      visibleFraction = 1;
    }

    assert(visibleFraction >= 0);
    assert(visibleFraction <= 1);
    return visibleFraction;
  }

  // endregion

  // region - constructor
  /// Constructor.
  ///
  /// `key` corresponds to the [Key] used to construct the corresponding
  /// [VisibilityDetector] widget.  Must not be null.
  ///
  /// If `size` or `visibleBounds` are omitted, the [VisibilitySnapshot]
  /// will be initialized to [Offset.zero] or [Rect.zero] respectively.  This
  /// will indicate that the corresponding widget is completely hidden.
  const VisibilitySnapshot({
    required this.key,
    this.size = Size.zero,
    this.visibleBounds = Rect.zero,
  });

  // endregion
  // region - factory
  /// Constructs a [VisibilitySnapshot] from widget bounds and a corresponding
  /// clipping rectangle.
  ///
  /// The [widgetBounds] and [clipRect] parameters are expected to be in the
  /// same coordinate system.
  factory VisibilitySnapshot.fromRectangles({
    required Key key,
    required Rect widgetBounds,
    required Rect clipRect,
  }) {
    final bool overlaps = widgetBounds.overlaps(clipRect);
    // Compute the intersection in the widget's local coordinates.
    final visibleBounds = overlaps
        ? widgetBounds.intersect(clipRect).shift(-widgetBounds.topLeft)
        : Rect.zero;

    return VisibilitySnapshot(
      key: key,
      size: widgetBounds.size,
      visibleBounds: visibleBounds,
    );
  }

  // endregion

  // region - override
  @override
  String toString() =>
      'VisibilitySnapshot(key: $key, size: $size visibleBounds: $visibleBounds)';

  @override
  int get hashCode => Object.hash(key, size, visibleBounds);

  @override
  bool operator ==(Object other) =>
      other is VisibilitySnapshot &&
      other.key == key &&
      other.size == size &&
      other.visibleBounds == visibleBounds;

  // endregion

  // region - public api
  /// Returns true if the specified [VisibilitySnapshot] object has equivalent
  /// visibility to this one.
  bool matchesVisibility(VisibilitySnapshot snapshot) {
    // We don't override `operator ==` so that object equality can be separate
    // from whether two [VisibilitySnapshot] objects are sufficiently similar
    // that we don't need to fire callbacks for both.  This could be pertinent
    // if other properties are added.
    return size == snapshot.size && visibleBounds == snapshot.visibleBounds;
  }

  // endregion
  // region - helper methods
  /// Returns the area of a rectangle of the specified dimensions.
  static double _area(Size size) {
    assert(size.width >= 0);
    assert(size.height >= 0);
    return size.width * size.height;
  }

  /// Returns whether two floating-point values are approximately equal.
  static bool _floatNear(double f1, double f2) {
    final absDiff = (f1 - f2).abs();
    return absDiff <= _defaultTolerance ||
        (absDiff / math.max(f1.abs(), f2.abs()) <= _defaultTolerance);
  }
// endregion
}
