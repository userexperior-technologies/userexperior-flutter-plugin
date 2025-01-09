import 'package:flutter/material.dart';

import '../scheduler/scheduler.dart';
import 'screenshot_recorder.dart';

class UEScheduledScreenshotRecorder extends UEScreenshotRecorder {
  @override
  String get logName => "UEScheduledScreenshotRecorder";

  late final UEScheduler _scheduler;
  final UEScreenshotRecorderCallback _callback;

  UEScheduledScreenshotRecorder(
      UEScreenshotRecorderCallback callback, int frameRate,
      {super.monitor})
      : _callback = callback,
        super() {
    final frameDuration = Duration(milliseconds: frameRate);
    _scheduler = UEScheduler(
        frameDuration, _capture, WidgetsBinding.instance.addPostFrameCallback);
  }

  void start() {
    debugPrint("$logName: starting capture.");
    _scheduler.start();
  }

  Future<void> stop() async {
    await _scheduler.stop();
    debugPrint("$logName: capture stopped.");
  }

  Future<void> _capture(Duration sinceSchedulerEpoch) async =>
      capture(_callback);
}
