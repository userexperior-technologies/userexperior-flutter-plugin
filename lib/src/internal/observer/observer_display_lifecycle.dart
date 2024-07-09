import 'package:flutter/widgets.dart';

import '../visibility/visibility_detector_snapshot.dart';
import '../visibility/visibility_detector_widget.dart';

class DisplayLifecycleObserver extends StatefulWidget {
  // region - attributes
  /// The widget to add functionality
  final Widget child;

  /// Callback on when screen is in focus
  final VoidCallback? _onGained;

  /// Callback on when screen is not in focus
  final VoidCallback? _onLost;

  // endregion

  // region - constructors
  const DisplayLifecycleObserver({
    super.key,
    onFocusGained,
    onFocusLost,
    required this.child,
  })  : _onGained = onFocusGained,
        _onLost = onFocusLost;

  // endregion

  // region - override
  @override
  State<DisplayLifecycleObserver> createState() =>
      _DisplayLifecycleObserverState();
// endregion
}

class _DisplayLifecycleObserverState extends State<DisplayLifecycleObserver>
    with WidgetsBindingObserver {
  // region - attributes
  final _visibilityDetectorKey = UniqueKey();
  late bool _isAppInForeground;
  late bool _isAppInVisible;

  // endregion

  // region - getters
  bool get isVisible => !_isAppInVisible && _isAppInForeground;

  // endregion

  // region - override
  @override
  void initState() {
    super.initState();
    _isAppInForeground = true;
    _isAppInVisible = false;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isAppInForeground =
        state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive;

    notifyToggleCallback();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetectorWidget(
      key: _visibilityDetectorKey,
      onVisibilityChanged: (VisibilitySnapshot snapshot) {
        _isAppInVisible = snapshot.visibleFraction == 0.0;
        notifyToggleCallback();
      },
      child: widget.child,
    );
  }

// endregion

  // region
  void notifyToggleCallback() =>
      isVisible ? widget._onGained?.call() : widget._onLost?.call();
// endregion
}
