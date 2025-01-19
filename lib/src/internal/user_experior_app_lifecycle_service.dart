import 'package:flutter/widgets.dart';

class UserExperiorAppLifecycle with WidgetsBindingObserver {
  static final UserExperiorAppLifecycle _instance =
      UserExperiorAppLifecycle._internal();

  bool isAppInForeground = true;
  AppLifecycleListener a = AppLifecycleListener(
    onResume: () => debugPrint('AppLifecycleListener state. Current state: resume'),
    onInactive: () => debugPrint('AppLifecycleListener state. Current state: inactive'),
    onHide: () => debugPrint('AppLifecycleListener state. Current state: hide'),
    onShow: () => debugPrint('AppLifecycleListener state. Current state: show'),
    onPause: () => debugPrint('AppLifecycleListener state. Current state: pause'),
    onRestart: () => debugPrint('AppLifecycleListener state. Current state: restart'),
    onDetach: () => debugPrint('AppLifecycleListener state. Current state: detach'),
  );

  factory UserExperiorAppLifecycle() {
    return _instance;
  }

  UserExperiorAppLifecycle._internal() {
    WidgetsBinding.instance.addObserver(this);
    _logLifecycleState(); // Optional: Log the initial state
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // debugPrint("AppLifecycleService state. Current state: ${state.toString()}");

    if (state == AppLifecycleState.resumed) {
      // App is in the foreground
      isAppInForeground = true;
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // App is in the background
      isAppInForeground = false;
    }
  }

  void _logLifecycleState() {
    debugPrint(
        "AppLifecycleService initialized. Current state: ${isAppInForeground ? "Foreground" : "Background"}");
  }

  static void dispose() {
    WidgetsBinding.instance.removeObserver(_instance);
  }
}
