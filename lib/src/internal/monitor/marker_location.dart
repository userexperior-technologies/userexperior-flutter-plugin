import 'dart:ui';
import '../observer/observer_display_lifecycle.dart';

class UEMarkerLocation {
  final String uuid;
  final Rect rect;
  bool get isValid => rect.isFinite && !rect.isEmpty && !rect.isInfinite;

  UEMarkerLocation({required this.uuid, required this.rect});

  Map<String, String> get toJson {
    double ratioToDouble(double value) => value * DisplayLifecycleObserver.devicePixelRatio;

    return {
      'i': uuid,
      'x': ratioToDouble(rect.left).toString(),
      'y': ratioToDouble(rect.top).toString(),
      'w': ratioToDouble(rect.width).toString(),
      'h': ratioToDouble(rect.height).toString(),
    };
  }
}
