import 'dart:ui';

class UEMarkerLocation {
  // region - attributes
  final String uuid;
  final Rect rect;

  bool get isValid => rect.isFinite && !rect.isEmpty && !rect.isInfinite;

  // endregion
  // region - constructor
  UEMarkerLocation({required this.uuid, required this.rect});
// endregion
}