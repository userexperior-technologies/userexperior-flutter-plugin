import 'dart:io';
import 'dart:ui';

class UEMarkerLocation {
  // region - attributes
  final String uuid;
  final Rect rect;
  bool get isValid => rect.isFinite && !rect.isEmpty && !rect.isInfinite;
  final bool isAndroid = Platform.isAndroid;
  final double devicePixelRatio = PlatformDispatcher.instance.views.first.devicePixelRatio;

  // endregion
  // region - constructor
  UEMarkerLocation({required this.uuid, required this.rect});
  // endregion

  Map<String, String> get toJson {
    double ratioToDouble(double value) => value * (isAndroid ? devicePixelRatio : 1.0);

    return {
      'i': uuid,
      'x': ratioToDouble(rect.left).toString(),
      'y': ratioToDouble(rect.top).toString(),
      'w': ratioToDouble(rect.width).toString(),
      'h': ratioToDouble(rect.height).toString(),
    };
  }
}
