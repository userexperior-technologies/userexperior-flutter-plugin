import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../ue_plugin.dart';
import 'extensions/extensions_method_channel.dart';
import 'extensions/extensions_util_marker_location.dart';
import 'monitor/marker_monitor_controller.dart';
import 'recorder/scheduled_screenshot_recorder.dart';
import 'scraper/render_tree.dart';
import 'user_experior_platform_interface.dart';

/// Native channels.
class Channels {
  static const MethodChannel channel = MethodChannel('user_experior');
}

/// An implementation of [UserExperiorPlatform] that uses method channels.
class MethodChannelUserExperior extends UserExperiorPlatform {
  // region - attributes
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel methodChannel;
  bool isTransitioningState = false;

  UEScheduledScreenshotRecorder? _recorder;

  // endregion
  // region - constructor
  MethodChannelUserExperior({this.methodChannel = Channels.channel}) : super() {
    methodChannel.setMethodCallHandler(_methodCallHandler);
  }

  // endregion
  static Uint8List? _screenshotImage;
  static bool _isProcessingScreenshot = false;

  static double get _devicePixelRatio {
    final views = PlatformDispatcher.instance.views;
    final onAndroid = Platform.isAndroid;
    return onAndroid ? views.first.devicePixelRatio : 1.0;
  }

  static Future<Map<String, dynamic>?> _captureScreenshot(RenderRepaintBoundary boundary) async {
    try {
      final watch = Stopwatch()..start();
      ui.Image image = await boundary.toImage(pixelRatio: _devicePixelRatio);
      int width = image.width;
      int height = image.height;

      debugPrint("ScreenshotRecorder02: screenshot taken in ${watch.elapsedMilliseconds}ms");
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      debugPrint("ScreenshotRecorder02: screenshot conversion in ${watch.elapsedMilliseconds}ms");
      image.dispose();

      if (byteData == null) return null;
      return {
        "screenshot": byteData.buffer.asUint8List(),
        "width": width,
        "height": height,
        "format": 0,
      };

    } catch (e) {
      debugPrint(e.toString());
      debugPrint("ScreenshotRecorder00: error: ${e.toString()}");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> _fetchScreenshot() async {
    if (_isProcessingScreenshot) {
      debugPrint("ScreenshotRecorder00: Skipping screenshot, still processing previous one.");
      return null; // Skip this request
    }
    _isProcessingScreenshot = true; // Mark as in progress
    debugPrint("ScreenshotRecorder00: Starting screenshot process");

    final watch = Stopwatch()..start();
    try {
      final renderObject = UERenderTreeUtils.firstAppRepaintBoundary();
      if (renderObject == null) {
        debugPrint("ScreenshotRecorder00: Render is not found, skipping frame capture.");
        return null;
      }
      debugPrint("ScreenshotRecorder01: search for render object ${watch.elapsedMilliseconds}ms.");
      var encodedData = await _captureScreenshot(renderObject);
      debugPrint("ScreenshotRecorder01: capture total finished ${watch.elapsedMilliseconds}ms.");
      return encodedData;
    } finally {
      _isProcessingScreenshot = false; // Mark as complete
    }
  }

  // region - Trigger from native
  Future<dynamic> _methodCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "fetchFlutterData":
        Map<String, dynamic> payload = Map.from({});
        var mode = methodCall.arguments["mode"] as String;

        if (mode == "full") {
          var locations = UEMarkerMonitorController.instance
              .getMarkerLocations()
              .map((e) => e.toJson)
              .toList();
          payload['locations'] = locations;
          payload['wireframe'] = "";
          debugPrint("ScreenshotRecorder01: _fetchScreenshot start");
          var screenshot = await _fetchScreenshot();
          debugPrint("ScreenshotRecorder01: _fetchScreenshot done");
          if (screenshot != null) {
            payload['screenshot'] = screenshot['screenshot'];
            payload['height'] = screenshot['height'];
            payload['width'] = screenshot['width'];
            payload['format'] = screenshot['format'];
          }
        }
        if (mode == "basic") {
          var locations = UEMarkerMonitorController.instance
              .getMarkerLocations()
              .map((e) => e.toJson)
              .toList();
          payload['locations'] = locations;

        }
        return payload;
      default:
        return null;
    }
  }

  // endregion

  // region - Trigger from flutter
  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethodOnMobile<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> updateTransitioningState(bool isTransitioning) async {
    if (isTransitioningState == isTransitioning) {
      return;
    }
    isTransitioningState = isTransitioning;
    await methodChannel.invokeMethodOnMobile(
        "updateTransitioningState", {"state": isTransitioning});
  }

  @override
  Future<void> startRecording(String ueVersionKey) async {
    await methodChannel.invokeMethodOnMobile('startRecording', {
      "ueVersionKey": ueVersionKey,
      "fw": UserExperior.fw,
      "sv": UserExperior.sv
    });

    // if (Platform.isAndroid) {
    //   callback(image) async {
    //     ByteData? byteData =
    //         await image.toByteData(format: ui.ImageByteFormat.png);
    //     if (byteData != null) {
    //       _screenshotImage = byteData.buffer.asUint8List();
    //       // String base64String = base64Encode(_screenshotImage!);
    //       // debugPrint(base64String);
    //     }
    //   }
    //
    //   _recorder = UEScheduledScreenshotRecorder(callback, 200)..start();
    // }
  }

  @override
  Future<void> stopRecording() async {
    // _recorder?.stop();
    await methodChannel.invokeMethodOnMobile('stopRecording');
    // _recorder = null;
  }

  @override
  Future<void> pauseRecording() async {
    // _recorder?.stop();
    await methodChannel.invokeMethodOnMobile('pauseRecording');
  }

  @override
  Future<void> resumeRecording() async {
    // _recorder?.start();
    await methodChannel.invokeMethodOnMobile('resumeRecording');
  }

  @override
  Future<void> setUserIdentifier(String userIdentifier) async {
    await methodChannel.invokeMethodOnMobile(
        'setUserIdentifier', {"userIdentifier": userIdentifier});
  }

  @override
  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    await methodChannel
        .invokeMethodOnMobile('setUserProperties', {"properties": properties});
  }

  @override
  Future<void> logEvent(String eventName) async {
    await methodChannel
        .invokeMethodOnMobile('logEvent', {"eventName": eventName});
  }

  @override
  Future<void> logEventWithProperties(
      String eventName, Map<String, dynamic> properties) async {
    await methodChannel.invokeMethodOnMobile('logEventWithProperties',
        {"eventName": eventName, "properties": properties});
  }

  @override
  Future<void> logMessage(String messageName) async {
    await methodChannel
        .invokeMethodOnMobile('logMessage', {"messageName": messageName});
  }

  @override
  Future<void> logMessageWithProperties(
      String messageName, Map<String, dynamic> properties) async {
    await methodChannel.invokeMethodOnMobile('logMessageWithProperties',
        {"messageName": messageName, "properties": properties});
  }

  @override
  Future<void> startScreen(String screenName) async {
    await methodChannel
        .invokeMethodOnMobile('startScreen', {"screenName": screenName});
  }

  @override
  Future<void> startTimer(String timerName) async {
    await methodChannel
        .invokeMethodOnMobile('startTimer', {"timerName": timerName});
  }

  @override
  Future<void> startTimerWithProperties(
      String timerName, Map<String, dynamic> properties) async {
    await methodChannel.invokeMethodOnMobile('startTimerWithProperties',
        {"timerName": timerName, "properties": properties});
  }

  @override
  Future<void> endTimer(String timerName) async {
    await methodChannel
        .invokeMethodOnMobile('endTimer', {"timerName": timerName});
  }

  @override
  Future<void> endTimerWithProperties(
      String timerName, Map<String, dynamic> properties) async {
    await methodChannel.invokeMethodOnMobile('endTimerWithProperties',
        {"timerName": timerName, "properties": properties});
  }

  @override
  Future<void> setDeviceLocation(double latitude, double longitude) async {
    await methodChannel.invokeMethodOnMobile(
        'setDeviceLocation', {"latitude": latitude, "longitude": longitude});
  }

  @override
  Future<void> optOut() async {
    await methodChannel.invokeMethodOnMobile('optOut');
  }

  @override
  Future<void> optIn() async {
    await methodChannel.invokeMethodOnMobile('optIn');
  }

  @override
  Future<bool?> getOptOutStatus() async {
    final bool? optOutStatus =
        await methodChannel.invokeMethodOnMobile('getOptOutStatus');
    return optOutStatus;
  }

  @override
  Future<bool?> isRecording() async {
    final bool? isRecording =
        await methodChannel.invokeMethodOnMobile('isRecording');
    return isRecording;
  }
// endregion
}
