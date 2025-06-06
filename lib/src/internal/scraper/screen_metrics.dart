import 'dart:io';
import 'dart:ui';
import 'package:flutter/widgets.dart';

/// A utility to track screen metrics (especially for devicePixelRatio changes).
class ScreenMetrics with WidgetsBindingObserver {
  static double _devicePixelRatio = _getDevicePixelRatio();

  /// Public getter for the current pixel ratio.
  /// Use this wherever device scaling is required.
  static double get devicePixelRatio => _devicePixelRatio;

  /// Singleton instance of [ScreenMetrics].
  /// Ensures only one observer is registered across the app lifecycle.
  static final ScreenMetrics _instance = ScreenMetrics._internal();

  /// Factory constructor to always return the singleton instance.
  factory ScreenMetrics() => _instance;

  /// Internal constructor that registers as an observer for screen metric changes.
  ScreenMetrics._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// Called automatically by Flutter when screen metrics change,
  /// such as orientation changes or multi-window resizing on supported devices.
  @override
  void didChangeMetrics() {
    _devicePixelRatio = _getDevicePixelRatio();
  }

  static double _getDevicePixelRatio() {
    final views = PlatformDispatcher.instance.views;
    return Platform.isAndroid ? views.first.devicePixelRatio : 1.0;
  }
}
