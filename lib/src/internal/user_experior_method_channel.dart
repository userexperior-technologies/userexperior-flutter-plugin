import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../ue_plugin.dart';
import 'extensions/extensions_method_channel.dart';
import 'extensions/extensions_util_marker_location.dart';
import 'monitor/marker_monitor_controller.dart';
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

  // endregion
  // region - constructor
  MethodChannelUserExperior({this.methodChannel = Channels.channel}) : super() {
    methodChannel.setMethodCallHandler(_methodCallHandler);
  }

  // endregion

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
          var screenshot = await _fetchScreenshot();
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

  bool _debugMode = false;

  // region - Trigger from flutter
  @override
  bool get debugMode {
    return _debugMode;
  }

  @override
  set debugMode(bool newValue) {
    _debugMode = newValue;
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
  }

  @override
  Future<void> stopRecording() async {
    await methodChannel.invokeMethodOnMobile('stopRecording');
  }

  @override
  Future<void> pauseRecording() async {
    await methodChannel.invokeMethodOnMobile('pauseRecording');
  }

  @override
  Future<void> resumeRecording() async {
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

// region - Screenshot helpers

  static bool _isProcessingScreenshot = false;

  static double get _devicePixelRatio {
    final views = PlatformDispatcher.instance.views;
    final onAndroid = Platform.isAndroid;
    return onAndroid ? views.first.devicePixelRatio : 1.0;
  }

  static Uint8List convertRawRgbaToArgb(Uint8List rgbaData) {
    final int length = rgbaData.length;
    final Uint8List argbData = Uint8List(length);

    for (int i = 0; i < length; i += 4) {
      argbData[i] = rgbaData[i + 3]; // Move A to front
      argbData[i + 1] = rgbaData[i]; // Move R
      argbData[i + 2] = rgbaData[i + 1]; // Move G
      argbData[i + 3] = rgbaData[i + 2]; // Move B
    }

    return argbData;
  }

  static Future<Map<String, dynamic>?> _captureScreenshot(
      RenderRepaintBoundary boundary, Stopwatch watch) async {
    try {
      // final watch = Stopwatch()..start();
      ui.Image image = await boundary.toImage(pixelRatio: _devicePixelRatio);
      int width = image.width;
      int height = image.height;
      if (UserExperior.debugMode) {
        debugPrint(
            "ScreenshotRecorder02: screenshot finished at ${watch.elapsedMilliseconds}ms");
      }
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
      if (UserExperior.debugMode) {
        debugPrint(
            "ScreenshotRecorder02: conversion to data finished at ${watch
                .elapsedMilliseconds}ms");
      }
      image.dispose();

      if (byteData == null) return null;

      Uint8List rgbaData = byteData.buffer.asUint8List();
      if (UserExperior.debugMode) {
        debugPrint(
            "ScreenshotRecorder02: conversion to rgbaData finished at ${watch
                .elapsedMilliseconds}ms");
      }
      Uint8List argbData = rgbaData; // convertRawRgbaToArgb(rgbaData);
      if (UserExperior.debugMode) {
        debugPrint(
            "ScreenshotRecorder02: conversion to argbData finished at ${watch
                .elapsedMilliseconds}ms");
      }
      // String base64String = base64Encode(byteData.buffer.asUint8List());
      // debugPrint(base64String);

      return {
        "screenshot": argbData,
        "width": width,
        "height": height,
        "format": 0,
      };
    } catch (e) {
      debugPrint(e.toString());
      if (UserExperior.debugMode) {
        debugPrint("ScreenshotRecorder00: error: ${e.toString()}");
      }
      return null;
    }
  }

  static Future<Map<String, dynamic>?> _fetchScreenshot() async {
    if (_isProcessingScreenshot) {
      return null; // Skip this request
    }
    _isProcessingScreenshot = true; // Mark as in progress
    final now = DateTime.now();
    try {
      final watch = Stopwatch()..start();
      final renderObject = UERenderTreeUtils.firstAppRepaintBoundary();
      if (renderObject == null) {
        if (UserExperior.debugMode) {
          debugPrint(
              "ScreenshotRecorder00: Render is not found, skipping frame capture.");
        }
        return null;
      }
      if (UserExperior.debugMode) {
        debugPrint(
            "ScreenshotRecorder01: search for render object finished at ${watch
                .elapsedMilliseconds}ms.");
      }
      var encodedData = await _captureScreenshot(renderObject, watch);
      if (UserExperior.debugMode) {
        debugPrint(
            "ScreenshotRecorder01: process finished at ${watch
                .elapsedMilliseconds}ms.");
      }
      return encodedData;
    } finally {
      _isProcessingScreenshot = false; // Mark as complete
    }
  }
// endregion
}
