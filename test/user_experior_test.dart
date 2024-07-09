import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:user_experior/src/internal/user_experior_method_channel.dart';
import 'package:user_experior/src/internal/user_experior_platform_interface.dart';
import 'package:user_experior/user_experior.dart';

class MockUserExperiorPlatform
    with MockPlatformInterfaceMixin
    implements UserExperiorPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> updateTransitioningState(bool isTransitioning) async {
    throw UnimplementedError();
  }

  @override
  Future<void> endTimer(String timerName) {
    // TODO: implement endTimer
    throw UnimplementedError();
  }

  @override
  Future<void> endTimerWithProperties(String timerName, Map<String, dynamic> properties) {
    // TODO: implement endTimerWithProperties
    throw UnimplementedError();
  }

  @override
  Future<bool?> getOptOutStatus() {
    // TODO: implement getOptOutStatus
    throw UnimplementedError();
  }

  @override
  Future<bool?> isRecording() {
    // TODO: implement isRecording
    throw UnimplementedError();
  }

  @override
  Future<void> logEvent(String eventName) {
    // TODO: implement logEvent
    throw UnimplementedError();
  }

  @override
  Future<void> logEventWithProperties(String eventName, Map<String, dynamic> properties) {
    // TODO: implement logEventWithProperties
    throw UnimplementedError();
  }

  @override
  Future<void> logMessage(String messageName) {
    // TODO: implement logMessage
    throw UnimplementedError();
  }

  @override
  Future<void> logMessageWithProperties(String messageName, Map<String, dynamic> properties) {
    // TODO: implement logMessageWithProperties
    throw UnimplementedError();
  }

  @override
  Future<void> optIn() {
    // TODO: implement optIn
    throw UnimplementedError();
  }

  @override
  Future<void> optOut() {
    // TODO: implement optOut
    throw UnimplementedError();
  }

  @override
  Future<void> pauseRecording() {
    // TODO: implement pauseRecording
    throw UnimplementedError();
  }

  @override
  Future<void> resumeRecording() {
    // TODO: implement resumeRecording
    throw UnimplementedError();
  }

  @override
  Future<void> setDeviceLocation(double latitude, double longitude) {
    // TODO: implement setDeviceLocation
    throw UnimplementedError();
  }

  @override
  Future<void> setUserIdentifier(String userIdentifier) {
    // TODO: implement setUserIdentifier
    throw UnimplementedError();
  }

  @override
  Future<void> setUserProperties(Map<String, dynamic> properties) {
    // TODO: implement setUserProperties
    throw UnimplementedError();
  }

  @override
  Future<void> startRecording(String ueVersionKey) {
    // TODO: implement startRecording
    throw UnimplementedError();
  }

  @override
  Future<void> startScreen(String screenName) {
    // TODO: implement startScreen
    throw UnimplementedError();
  }

  @override
  Future<void> startTimer(String timerName) {
    // TODO: implement startTimer
    throw UnimplementedError();
  }

  @override
  Future<void> startTimerWithProperties(String timerName, Map<String, dynamic> properties) {
    // TODO: implement startTimerWithProperties
    throw UnimplementedError();
  }

  @override
  Future<void> stopRecording() {
    // TODO: implement stopRecording
    throw UnimplementedError();
  }
}

void main() {

  final UserExperiorPlatform initialPlatform = UserExperiorPlatform.instance;

  test('$MethodChannelUserExperior is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUserExperior>());
  });

  test('getPlatformVersion', () async {
    UserExperior userExperiorPlugin = UserExperior();
    MockUserExperiorPlatform fakePlatform = MockUserExperiorPlatform();
    UserExperiorPlatform.instance = fakePlatform;

    expect(await userExperiorPlugin.getPlatformVersion(), '42');
  });
}
