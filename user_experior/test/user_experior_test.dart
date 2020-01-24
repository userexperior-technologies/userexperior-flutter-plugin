import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_experior/user_experior.dart';

void main() {
  const MethodChannel channel = MethodChannel('user_experior');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await UserExperior.platformVersion, '42');
  });
}
