import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../monitor/marker_location.dart';
import '../monitor/marker_monitor_controller.dart';
import '../scraper/render_tree.dart';
import '../user_experior_app_lifecycle_service.dart';

typedef UEScreenshotRecorderCallback = Future<void> Function(ui.Image);

class UEScreenshotRecorder {
  // region - computed properties
  static double get _devicePixelRatio {
    final views = PlatformDispatcher.instance.views;
    final onAndroid = Platform.isAndroid;
    return onAndroid ? views.first.devicePixelRatio : 1.0;
  }

  String get logName => "UEScreenshotRecorder";

  RenderRepaintBoundary? get _lazyMonitoredRender {
    _monitoredRender ??= UERenderTreeUtils.firstAppRepaintBoundary();
    return _monitoredRender;
  }

  // region - stored properties
  RenderRepaintBoundary? _monitoredRender;
  final UEMarkerMonitorController _locationsController;

  // region - constructor
  UEScreenshotRecorder({UEMarkerMonitorController? monitor})
      : _locationsController = monitor ?? UEMarkerMonitorController.instance;

  // region - private methods
  void _reduceLocations(Canvas canvas, List<UEMarkerLocation> items) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = Colors.black;

    final pixelRatio = _devicePixelRatio;

    for (var item in items) {
      // Adjust the rect to account for the pixel ratio
      final adjustedRect = Rect.fromLTRB(
        item.rect.left * pixelRatio,
        item.rect.top * pixelRatio,
        item.rect.right * pixelRatio,
        item.rect.bottom * pixelRatio,
      );
      // Draw the adjusted rect
      canvas.drawRect(adjustedRect, paint);
    }
  }

  // region - public methods
  Future<void> capture(UEScreenshotRecorderCallback callback) async {
    if (!UserExperiorAppLifecycle().isAppInForeground) {
      debugPrint("$logName: Application is not in the Foreground, "
          "skipping frame capture.");
      return;
    }

    final renderObject = UERenderTreeUtils.firstAppRepaintBoundary();
    if (renderObject == null) {
      debugPrint("$logName: Render is not found, "
          "skipping frame capture.");
      return;
    }

    try {
      final watch = Stopwatch()..start();

      // On Android, the desired resolution (coming from the configuration)
      // is rounded to next multitude of 16 . Therefore, we scale the image.
      // On iOS, the screenshot resolution is not adjusted.
      final srcWidth = renderObject.size.width;
      final srcHeight = renderObject.size.height;

      final pixelRatio = _devicePixelRatio;

      if (renderObject.debugNeedsPaint) {
        return;
      }
      // First, we synchronously capture the image and enumerate widgets on the main UI loop.
      final futureImage = renderObject.toImage(pixelRatio: pixelRatio);
      final futureMasks = _locationsController.getMarkerLocations();
      final blockingTime = watch.elapsedMilliseconds;

      // Then we draw the image and obscure collected coordinates asynchronously.
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final image = await futureImage;
      try {
        canvas.drawImage(image, Offset.zero, Paint());
      } finally {
        image.dispose();
      }

      if (futureMasks.isNotEmpty) _reduceLocations(canvas, futureMasks);

      final picture = recorder.endRecording();

      try {
        final finalImage = await picture.toImage(
            (srcWidth * pixelRatio).round(), (srcHeight * pixelRatio).round());
        try {
          await callback(finalImage);
        } finally {
          finalImage.dispose(); // image needs to be disposed manually
        }
      } finally {
        picture.dispose();
      }

      debugPrint("$logName: captured a screenshot in "
          "${watch.elapsedMilliseconds}ms "
          "($blockingTime ms blocking).");
    } catch (e, stackTrace) {
      debugPrint("$logName: failed to capture screenshot.\n"
          "${e.toString()}\n"
          "${stackTrace.toString()}");
    }
  }
}