import 'dart:async';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'render_tree.dart';

class UESnapshotter {
  static bool _isProcessingScreenshot = false;

  static final double _devicePixelRatio = _getDevicePixelRatio();

  static double _getDevicePixelRatio() {
    final views = PlatformDispatcher.instance.views;
    final onAndroid = Platform.isAndroid;
    return onAndroid ? views.first.devicePixelRatio : 1.0;
  }
  // these 3 are also running fine
  static Future<Map<String, dynamic>?> fetchScreenshot() async {
    if (_isProcessingScreenshot) return null;

    _isProcessingScreenshot = true;
    try {
      // Delay screenshot to allow the UI to settle: delay affects masking to not work properly
      //await Future.delayed(const Duration(milliseconds: 200));

      final RenderRepaintBoundary? boundary = UERenderTreeUtils.firstAppRepaintBoundary();

      if (boundary == null) {
        debugPrint("ScreenshotRecorder: No repaint boundary found.");
        return null;
      }

      // Ensure screenshot is captured after current frame
      return await _captureAfterNextFrame(boundary);
    } finally {
      _isProcessingScreenshot = false;
    }
  }

  static Future<Map<String, dynamic>?> _captureAfterNextFrame(
      RenderRepaintBoundary boundary) async {
    final completer = Completer<Map<String, dynamic>?>();

    // Wait until the frame is painted
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final result = await _captureScreenshot(boundary);
        completer.complete(result);
      } catch (e, stackTrace) {
        debugPrint("ScreenshotRecorder: Exception: $e\n$stackTrace");
        completer.complete(null);
      }
    });

    return completer.future;
  }

  static Future<Map<String, dynamic>?> _captureScreenshot(
      RenderRepaintBoundary boundary) async {
    try {
      final ui.Image image =
      await boundary.toImage(pixelRatio: _devicePixelRatio);

      final int width = image.width;
      final int height = image.height;

      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.rawStraightRgba,
      );
      image.dispose(); // Free GPU memory

      if (byteData == null) return null;

      final Uint8List rgbaData = byteData.buffer.asUint8List();

      // Clean up large references early
      byteData = null;

      return {
        "screenshot": rgbaData,
        "width": width,
        "height": height,
        "format": 0,
      };
    } catch (e, stackTrace) {
      debugPrint("ScreenshotRecorder: Capture failed: $e\n$stackTrace");
      return null;
    }
  }
}
