import 'dart:io';
import 'dart:ui';

extension ExtensionUtilDouble on double {
  double get ratioToDouble {
    final bool isAndroid = Platform.isAndroid;
    final double pixelRatio =
        PlatformDispatcher.instance.views.first.devicePixelRatio;
    return (this * (isAndroid ? pixelRatio : 1.0));
  }
}
