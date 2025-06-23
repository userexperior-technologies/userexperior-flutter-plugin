import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class UERenderTreeUtils {
  /// Finds the first `RenderRepaintBoundary` that is visible, valid, and painted.
  ///
  /// Uses a breadth-first traversal to avoid deep recursion.
  /// Includes defensive checks to ensure the boundary is usable.
  static RenderRepaintBoundary? firstAppRepaintBoundary() {
    final rootElement = WidgetsBinding.instance.rootElement;
    if (rootElement == null) {
      debugPrint("UERenderTreeUtils: rootElement is null.");
      return null;
    }

    final RenderObject? rootRenderObject = rootElement.renderObject;
    if (rootRenderObject == null) {
      debugPrint("UERenderTreeUtils: rootRenderObject is null.");
      return null;
    }

    final List<RenderObject> queue = [rootRenderObject];
    int scannedCount = 0;

    while (queue.isNotEmpty) {
      final RenderObject current = queue.removeAt(0);
      scannedCount++;

      if (current is RenderRepaintBoundary) {
        final bool isValid = current.attached &&
            !current.debugNeedsPaint &&
            current.size.isFinite &&
            current.size.width > 0 &&
            current.size.height > 0;

        if (isValid) {
          debugPrint("UERenderTreeUtils: Found valid boundary after scanning $scannedCount nodes.");
          return current;
        }
      }

      current.visitChildren((child) {
        // Extra check: only traverse if the child is attached
        if (child.attached) {
          queue.add(child);
        }
      });
    }

    debugPrint("UERenderTreeUtils: No valid boundary found after scanning $scannedCount nodes.");
    return null;
  }
}
