/// Public scheduler ticker task
typedef SchedulerTickerTask = Future<void> Function(Duration);

/// Internal type
typedef _SchedulerTickCallback = void Function(Duration timeStamp);

/// This is a low-priority scheduler.
/// We're not using Timer.periodic() because it may schedule a callback
/// even if the previous call hasn't finished (or started) yet.
/// Instead, we manually schedule a callback with a given delay after the
/// previous callback finished. Therefore, if the capture takes too long, we
/// won't overload the system. We sacrifice the frame rate for performance.
class UEScheduler {
  final SchedulerTickerTask _callback;
  final Duration _interval;
  bool _running = false;
  Future<void>? _scheduled;

  final void Function(_SchedulerTickCallback callback) _addPostFrameCallback;

  UEScheduler(this._interval, this._callback, this._addPostFrameCallback);

  void start() {
    _running = true;
    if (_scheduled == null) {
      _runAfterNextFrame();
    }
  }

  Future<void> stop() async {
    _running = false;
    final scheduled = _scheduled;
    _scheduled = null;
    if (scheduled != null) {
      await scheduled;
    }
  }

  @pragma('vm:prefer-inline')
  void _scheduleNext() {
    _scheduled ??= Future.delayed(_interval, _runAfterNextFrame);
  }

  @pragma('vm:prefer-inline')
  void _runAfterNextFrame() {
    _scheduled = null;
    _addPostFrameCallback(_run);
  }

  void _run(Duration sinceSchedulerEpoch) {
    if (!_running) return;
    _callback(sinceSchedulerEpoch).then((_) => _scheduleNext());
  }
}
