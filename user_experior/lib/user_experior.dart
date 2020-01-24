import 'dart:async';

import 'package:flutter/services.dart';

class UserExperior {
  static const MethodChannel _channel =
      const MethodChannel('user_experior');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  static void startRecording(String ueVersionKey) async{
    await _channel. invokeMethod('startRecording',{"ueVersionKey":ueVersionKey});
  }
  static Future<void> stopRecording() async{
    await _channel.invokeMethod('stopRecording');
  }
  static Future<void> pauseRecording() async{
    await _channel.invokeMethod('pauseRecording');
  }
  static Future<void> resumeRecording() async{
    await _channel.invokeMethod('resumeRecording');
  }
  static Future<void> setUserIdentifier(String userIdentifier) async{
    await _channel.invokeMethod('setUserIdentity',{"userIdentifier":userIdentifier});
  }
  static Future<void> setCustomTag(String customTag, String customType) async{
    await _channel.invokeMethod('setCustomTag',{"customTag":customTag, "customType":customType});
  }
  static Future<void> startScreen(String screenName) async{
    await _channel.invokeMethod('startScreen',{"screenName":screenName});
  }
  /*static Future<void> startTimer(String timerName) async{
    await _channel.invokeMethod('startTimer',{"timerName":timerName});
  }
  static Future<void> endTimer(String timerName) async{
    await _channel.invokeMethod('endTimer',{"timerName":timerName});
  }
  static Future<void> setDeviceLocation(double latitude, double longitude) async{
    await _channel.invokeMethod('endTimer',{"latitude":latitude, "longitude":longitude});
  }*/
  static Future<void> optOut() async{
    await _channel.invokeMethod('optOut');
  }
  static Future<void> optIn() async{
    await _channel.invokeMethod('optIn');
  }
  static Future<bool> getOptOutStatus() async{
    final bool optOutStatus= await _channel.invokeMethod('getOptOutStatus');
    return optOutStatus;
  }
  static Future<void> consent() async{
    await _channel.invokeMethod('consent');
  }
}
