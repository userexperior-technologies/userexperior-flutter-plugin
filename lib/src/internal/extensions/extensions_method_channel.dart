import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

extension MethodChannelMobile on MethodChannel {

  Future<T?> invokeMethodOnMobile<T>(String method, [dynamic arguments]) {
    return kIsWeb ? Future.value(null) : invokeMethod(method, arguments);
  }
}
