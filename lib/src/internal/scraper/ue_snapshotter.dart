import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'render_tree.dart';
import '../observer/observer_display_lifecycle.dart';

class UESnapshotter {
  // Prevent concurrent screenshot processing.
  static bool _isProcessingScreenshot = false;

  /// Triggers a screenshot capture from the first app render object.
  static Future<Map<String, dynamic>?> fetchEncodedScreenshot() async {
    if (_isProcessingScreenshot) return null;

    _isProcessingScreenshot = true;
    try {
      final RenderRepaintBoundary? boundary = UERenderTreeUtils.firstAppRepaintBoundary();

      if (boundary == null) {
        debugPrint("UESnapshotter: No repaint boundary found.");
        return null;
      }

      // Ensure screenshot is captured after current frame.
      return await _captureAfterNextFrame(boundary);
    } finally {
      _isProcessingScreenshot = false;
    }
  }

  static Future<Map<String, dynamic>?> _captureAfterNextFrame(RenderRepaintBoundary boundary) async {
    final completer = Completer<Map<String, dynamic>?>();

    // Check if Flutter has already scheduled a frame.
    // If not, request a new frame. This ensures that the widget tree
    // has time to layout and paint before we try to capture it.
    //
    // This step is crucial for single-screen apps or situations
    // where no frame transition (e.g., no setState/navigation) occurs,
    // as the UI may otherwise appear blank or unpainted.
    if (!WidgetsBinding.instance.hasScheduledFrame) {
      WidgetsBinding.instance.scheduleFrame();
    }

    // Wait for full frame to complete.
    await WidgetsBinding.instance.endOfFrame;

    // Ensure UI is painted.
    await Future.delayed(Duration.zero);

    // Use microtask to ensure execution after rendering.
    Future.microtask(() async {
      try {
        // Validate boundary one last time before capture
        if (boundary.debugNeedsPaint || boundary.size.isEmpty || !boundary.attached) {
          debugPrint("UESnapshotter: Boundary not ready. Skipping screenshot.");
          completer.complete(null);
          return;
        }

        final imageData = await _captureScreenshot(boundary);
        completer.complete(imageData);
      } catch (e, stackTrace) {
        debugPrint("UESnapshotter: Screenshot error: $e\n$stackTrace");
        completer.complete(null);
      }
    });

    return completer.future;
  }

  /// Captures a screenshot from the given [RenderRepaintBoundary].
  static Future<Map<String, dynamic>?> _captureScreenshot(RenderRepaintBoundary boundary) async {
    try {
      final ui.Image image = await boundary.toImage(pixelRatio: DisplayLifecycleObserver.devicePixelRatio);
      final int width = image.width;
      final int height = image.height;

      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawStraightRgba);

      // Free GPU memory.
      image.dispose();

      if (byteData == null) return null;

      final Uint8List rgbaData = byteData.buffer.asUint8List();

      // Clean up large references early.
      byteData = null;

      return {
        "screenshot": rgbaData,
        "width": width,
        "height": height,
        "format": 0,
      };
    } catch (e) {
      debugPrint("UESnapshotter: Exception in _captureScreenshot: $e");
      return null;
    }
  }
}
