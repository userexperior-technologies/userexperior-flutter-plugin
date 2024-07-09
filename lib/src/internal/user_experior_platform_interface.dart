import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'user_experior_method_channel.dart';

abstract class UserExperiorPlatform extends PlatformInterface {
  /// Constructs a UserExperiorPlatform.
  UserExperiorPlatform() : super(token: _token);

  static final Object _token = Object();

  static UserExperiorPlatform _instance = MethodChannelUserExperior();

  /// The default instance of [UserExperiorPlatform] to use.
  ///
  /// Defaults to [MethodChannelUserExperior].
  static UserExperiorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UserExperiorPlatform] when
  /// they register themselves.
  static set instance(UserExperiorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> updateTransitioningState(bool isTransitioning) async {
    throw UnimplementedError('updateTransitioningState() has not been implemented.');
  }

  // region - legacy api
  Future<void> startRecording(String ueVersionKey) async {
    throw UnimplementedError('startRecording() has not been implemented.');
  }

  Future<void> stopRecording() async {
    throw UnimplementedError('stopRecording() has not been implemented.');
  }

  Future<void> pauseRecording() async {
    throw UnimplementedError('pauseRecording() has not been implemented.');
  }

  Future<void> resumeRecording() async {
    throw UnimplementedError('resumeRecording() has not been implemented.');
  }

  Future<void> setUserIdentifier(String userIdentifier) async {
    throw UnimplementedError('setUserIdentifier() has not been implemented.');
  }

  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    throw UnimplementedError('setUserProperties() has not been implemented.');
  }

  Future<void> logEvent(String eventName) async {
    throw UnimplementedError('logEvent() has not been implemented.');
  }

  Future<void> logEventWithProperties(
      String eventName, Map<String, dynamic> properties) async {
    throw UnimplementedError('logEventWithProperties() has not been implemented.');
  }

  Future<void> logMessage(String messageName) async {
    throw UnimplementedError('logMessage() has not been implemented.');
  }

  Future<void> logMessageWithProperties(
      String messageName, Map<String, dynamic> properties) async {
    throw UnimplementedError('logMessageWithProperties() has not been implemented.');
  }

  Future<void> startScreen(String screenName) async {
    throw UnimplementedError('startScreen() has not been implemented.');
  }

  Future<void> startTimer(String timerName) async {
    throw UnimplementedError('startTimer() has not been implemented.');
  }

  Future<void> startTimerWithProperties(
      String timerName, Map<String, dynamic> properties) async {
    throw UnimplementedError('startTimerWithProperties() has not been implemented.');
  }

  Future<void> endTimer(String timerName) async {
    throw UnimplementedError('endTimer() has not been implemented.');
  }

  Future<void> endTimerWithProperties(
      String timerName, Map<String, dynamic> properties) async {
    throw UnimplementedError('endTimerWithProperties() has not been implemented.');
  }

  Future<void> setDeviceLocation(double latitude, double longitude) async {
    throw UnimplementedError('setDeviceLocation() has not been implemented.');
  }

  Future<void> optOut() async {
    throw UnimplementedError('optOut() has not been implemented.');
  }

  Future<void> optIn() async {
    throw UnimplementedError('optIn() has not been implemented.');
  }

  Future<bool?> getOptOutStatus() async {
    throw UnimplementedError('getOptOutStatus() has not been implemented.');
  }

  Future<bool?> isRecording() async {
    throw UnimplementedError('isRecording() has not been implemented.');
  }
  // endregion

}
