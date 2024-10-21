import 'dart:async';

import 'internal/user_experior_platform_interface.dart';

class UserExperior {
  static const fw = "fr";
  static const sv = "5.0.3"; // SDK/Plugin version

  static final UserExperior _instance = UserExperior();
  /// The default instance of [UserExperior] to use.
  static UserExperior get instance => _instance;

  Future<String?> getPlatformVersion() {
    return UserExperiorPlatform.instance.getPlatformVersion();
  }

  Future<void> updateTransitioningState(bool isTransitioning) async {
    await UserExperiorPlatform.instance
        .updateTransitioningState(isTransitioning);
  }

  // region - legacy api
  Future<void> startRecording(String ueVersionKey) async {
    await UserExperiorPlatform.instance.startRecording(ueVersionKey);
  }

  Future<void> stopRecording() async {
    await UserExperiorPlatform.instance.stopRecording();
  }

  Future<void> pauseRecording() async {
    await UserExperiorPlatform.instance.pauseRecording();
  }

  Future<void> resumeRecording() async {
    await UserExperiorPlatform.instance.resumeRecording();
  }

  Future<void> setUserIdentifier(String userIdentifier) async {
    await UserExperiorPlatform.instance.setUserIdentifier(userIdentifier);
  }

  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    await UserExperiorPlatform.instance.setUserProperties(properties);
  }

  Future<void> logEvent(String eventName) async {
    await UserExperiorPlatform.instance.logEvent(eventName);
  }

  Future<void> logEventWithProperties(
      String eventName, Map<String, dynamic> properties) async {
    await UserExperiorPlatform.instance
        .logEventWithProperties(eventName, properties);
  }

  Future<void> logMessage(String messageName) async {
    await UserExperiorPlatform.instance.logMessage(messageName);
  }

  Future<void> logMessageWithProperties(
      String messageName, Map<String, dynamic> properties) async {
    await UserExperiorPlatform.instance
        .logMessageWithProperties(messageName, properties);
  }

  Future<void> startScreen(String screenName) async {
    await UserExperiorPlatform.instance.startScreen(screenName);
  }

  Future<void> startTimer(String timerName) async {
    await UserExperiorPlatform.instance.startTimer(timerName);
  }

  Future<void> startTimerWithProperties(
      String timerName, Map<String, dynamic> properties) async {
    await UserExperiorPlatform.instance
        .startTimerWithProperties(timerName, properties);
  }

  Future<void> endTimer(String timerName) async {
    await UserExperiorPlatform.instance.endTimer(timerName);
  }

  Future<void> endTimerWithProperties(
      String timerName, Map<String, dynamic> properties) async {
    await UserExperiorPlatform.instance
        .endTimerWithProperties(timerName, properties);
  }

  Future<void> setDeviceLocation(double latitude, double longitude) async {
    await UserExperiorPlatform.instance.setDeviceLocation(latitude, longitude);
  }

  Future<void> optOut() async {
    await UserExperiorPlatform.instance.optOut();
  }

  Future<void> optIn() async {
    await UserExperiorPlatform.instance.optIn();
  }

  Future<bool?> getOptOutStatus() async {
    return await UserExperiorPlatform.instance.getOptOutStatus();
  }

  Future<bool?> isRecording() async {
    return await UserExperiorPlatform.instance.isRecording();
  }
}
