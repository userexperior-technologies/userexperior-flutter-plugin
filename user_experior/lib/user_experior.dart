import 'dart:async';

import 'package:flutter/services.dart';

class UserExperior {
  static final fw = "fr";
  static final sv = "4.1.1"; // SDK/Plugin version

  static const MethodChannel _channel = const MethodChannel('user_experior');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void startRecording(String ueVersionKey) async {
    await _channel.invokeMethod(
        'startRecording', {"ueVersionKey": ueVersionKey, "fw": fw, "sv": sv});
  }

  static Future<void> stopRecording() async {
    await _channel.invokeMethod('stopRecording');
  }

  static Future<void> pauseRecording() async {
    await _channel.invokeMethod('pauseRecording');
  }

  static Future<void> resumeRecording() async {
    await _channel.invokeMethod('resumeRecording');
  }

  static Future<void> setUserIdentifier(String userIdentifier) async {
    await _channel
        .invokeMethod('setUserIdentifier', {"userIdentifier": userIdentifier});
  }

  static Future<void> setUserProperties(Map<String, dynamic> properties) async {
    await _channel
        .invokeMethod('setUserProperties', {"properties": properties});
  }

  static Future<void> logEvent(String eventName) async {
    await _channel.invokeMethod('logEvent', {"eventName": eventName});
  }

  static Future<void> logEventWithProperties(
      String eventName, Map<String, dynamic> properties) async {
    await _channel.invokeMethod('logEventWithProperties',
        {"eventName": eventName, "properties": properties});
  }

  static Future<void> logMessage(String messageName) async {
    await _channel.invokeMethod('logMessage', {"messageName": messageName});
  }

  static Future<void> logMessageWithProperties(
      String messageName, Map<String, dynamic> properties) async {
    await _channel.invokeMethod('logMessageWithProperties',
        {"messageName": messageName, "properties": properties});
  }

  static Future<void> startScreen(String screenName) async {
    await _channel.invokeMethod('startScreen', {"screenName": screenName});
  }

  static Future<void> startTimer(String timerName) async {
    await _channel.invokeMethod('startTimer', {"timerName": timerName});
  }

  static Future<void> startTimerWithProperties(
      String timerName, Map<String, dynamic> properties) async {
    await _channel.invokeMethod('startTimerWithProperties',
        {"timerName": timerName, "properties": properties});
  }

  static Future<void> endTimer(String timerName) async {
    await _channel.invokeMethod('endTimer', {"timerName": timerName});
  }

  static Future<void> endTimerWithProperties(
      String timerName, Map<String, dynamic> properties) async {
    await _channel.invokeMethod('endTimerWithProperties',
        {"timerName": timerName, "properties": properties});
  }

  static Future<void> setDeviceLocation(
      double latitude, double longitude) async {
    await _channel.invokeMethod(
        'setDeviceLocation', {"latitude": latitude, "longitude": longitude});
  }

  static Future<void> optOut() async {
    await _channel.invokeMethod('optOut');
  }

  static Future<void> optIn() async {
    await _channel.invokeMethod('optIn');
  }

  static Future<bool?> getOptOutStatus() async {
    final bool? optOutStatus = await _channel.invokeMethod('getOptOutStatus');
    return optOutStatus;
  }

  static Future<bool?> isRecording() async {
    final bool? isRecording = await _channel.invokeMethod('isRecording');
    return isRecording;
  }

  //static Future<void> activateThirdPartyAnalyticsMonitor() async {
  //await _channel.invokeMethod('activateThirdPartyAnalyticsMonitor');
  //}
}
