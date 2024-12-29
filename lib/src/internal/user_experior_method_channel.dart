import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../ue_plugin.dart';
import 'monitor/marker_monitor_controller.dart';
import 'user_experior_platform_interface.dart';
import 'extensions/extensions_method_channel.dart';
import 'extensions/extensions_util_marker_location.dart';

/// Native channels.
class Channels {
  static const MethodChannel channel = MethodChannel('user_experior');
}

class RenderTreeNode {
  final String type;
  final String description;
  final RenderObject renderObject;
  final List<RenderTreeNode> children;

  RenderTreeNode({
    required this.type,
    required this.description,
    required this.renderObject,
    required this.children,
  });

  @override
  String toString() {
    return 'RenderTreeNode(type: $type, description: $description, children: $children)';
  }
}

class RenderTreeScraper {
  static RenderTreeNode scrape(RenderObject renderObject) {
    List<RenderTreeNode> children = [];

    renderObject.visitChildren((child) {
      children.add(scrape(child));
    });

    return RenderTreeNode(
      type: renderObject.runtimeType.toString(),
      description: renderObject.toStringShort(),
      renderObject: renderObject,
      children: children,
    );
  }

  static RenderTreeNode? scrapeFromContext(BuildContext context) {
    final renderObject = context.findRenderObject();
    if (renderObject != null) {
      return scrape(renderObject);
    }
    return null;
  }
}

class RenderTreeUtils {
  static List<RenderRepaintBoundary> findRepaintBoundaries(
      RenderTreeNode node) {
    List<RenderRepaintBoundary> repaintBoundaries = [];

    // Check if the current node's RenderObject is a RenderRepaintBoundary
    if (node.renderObject is RenderRepaintBoundary) {
      repaintBoundaries.add(node.renderObject as RenderRepaintBoundary);
    }

    // Recursively check children
    for (RenderTreeNode child in node.children) {
      repaintBoundaries.addAll(findRepaintBoundaries(child));
    }

    return repaintBoundaries;
  }
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
  static Future<String?> _fetchScreenshot() async {
    var rootElement = WidgetsBinding.instance.rootElement;
    if (rootElement != null) {
      final renderTree = RenderTreeScraper.scrapeFromContext(rootElement);
      if (renderTree != null) {
        // Find all RenderRepaintBoundary nodes
        final repaintBoundaries =
            RenderTreeUtils.findRepaintBoundaries(renderTree);
        if (repaintBoundaries.isNotEmpty) {
          var testBase64String = await _captureScreenshot(repaintBoundaries[0]);
          debugPrint(testBase64String!);
          return testBase64String;
        }
      } else {
        debugPrint("Failed to scrape the render tree.");
      }
    }
    return null;
  }

  static Future<String?> _captureScreenshot(
      RenderRepaintBoundary boundary) async {
    try {
      final watch = Stopwatch()..start();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final blockingTime = watch.elapsedMilliseconds;
      debugPrint(
          "ScreenshotRecorder: captured a screenshot in ${watch.elapsedMilliseconds}ms ($blockingTime ms blocking).");
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      String base64String = base64Encode(byteData.buffer.asUint8List());
      return base64String;
      // return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // region - Trigger from native
  Future<dynamic> _methodCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "getMarkerLocations":
        var screenshot = await _fetchScreenshot();
        var controller = UEMarkerMonitorController.instance;
        var rawLocations = controller.getMarkerLocations();
        var encLocations = rawLocations.map((e) => e.toJson).toList();
        Map<String, dynamic> payload = Map.from({});
        payload['locations'] = encLocations;
        if (screenshot != null && screenshot.isNotEmpty) {
          payload['image'] = screenshot;
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
}
