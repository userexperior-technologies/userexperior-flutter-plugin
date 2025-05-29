import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class UERenderTreeUtils {
  static bool showLogs = true;

  // Iterative traversal to find the first RenderRepaintBoundary,
  // avoiding recursion and deep call stacks.
  static RenderRepaintBoundary? firstAppRepaintBoundary() {
    final rootElement = WidgetsBinding.instance.rootElement;
    if (rootElement == null) return null;

    final RenderObject? rootRenderObject = rootElement.findRenderObject();
    if (rootRenderObject == null) return null;

    // Use a queue for breadth-first traversal
    final List<RenderObject> queue = [rootRenderObject];

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      if (current is RenderRepaintBoundary) {
        if (showLogs) {
          debugPrint(
              "UERenderTreeUtils: firstAppRepaintBoundary found at ${current.runtimeType}");
        }
        return current;
      }

      current.visitChildren(queue.add);
    }

    if (showLogs) {
      debugPrint("UERenderTreeUtils: No RenderRepaintBoundary found.");
    }
    return null;
  }
}
