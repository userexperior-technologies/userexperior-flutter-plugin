import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'render_node.dart';

class UERenderTreeUtils {
  static bool showLogs = true;

  static UERenderNode _scrape(RenderObject renderObject) {
    final children = <UERenderNode>[];
    renderObject.visitChildren((child) => children.add(_scrape(child)));

    return UERenderNode(
      type: renderObject.runtimeType.toString(),
      description: renderObject.toStringShort(),
      renderObject: renderObject,
      children: children,
    );
  }

  static UERenderNode? _scrapeFromContext(BuildContext context) {
    final renderObject = context.findRenderObject();
    return renderObject != null ? _scrape(renderObject) : null;
  }

  static List<RenderRepaintBoundary> _findRepaintBoundaries(UERenderNode node) {
    final repaintBoundaries = <RenderRepaintBoundary>[];

    if (node.renderObject is RenderRepaintBoundary) {
      repaintBoundaries.add(node.renderObject as RenderRepaintBoundary);
    }

    for (final child in node.children) {
      repaintBoundaries.addAll(_findRepaintBoundaries(child));
    }

    return repaintBoundaries;
  }

  static RenderRepaintBoundary? firstAppRepaintBoundary() {
    final watch = Stopwatch()..start();
    final rootElement = WidgetsBinding.instance.rootElement;
    if (rootElement == null) return null;

    final UERenderNode? tree = _scrapeFromContext(rootElement);
    if (tree == null) return null;

    final boundaries = _findRepaintBoundaries(tree);
    if (showLogs) {
      debugPrint(
          "UERenderTreeUtils: firstAppRepaintBoundary took ${watch.elapsedMilliseconds}ms.");
    }
    return boundaries.isEmpty ? null : boundaries[0];
  }
}
