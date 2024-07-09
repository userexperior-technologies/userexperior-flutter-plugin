import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ExtensionGlobalKey on GlobalKey {
  Rect get globalPaintBounds {

    // return globalBounds;
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return Rect.zero;
    }
  }

  Rect get globalBounds {
    final renderObject = currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      Offset position = renderObject.localToGlobal(Offset.zero);
      return Rect.fromLTWH(position.dx, position.dy, renderObject.size.width,
          renderObject.size.height);
    } else {
      return Rect.zero;
    }
  }
}
