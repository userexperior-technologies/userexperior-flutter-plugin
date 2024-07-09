import 'dart:math';
import 'package:flutter/material.dart';

import 'internal/monitor/marker_location.dart';
import 'internal/monitor/marker_monitor_controller.dart';
import 'internal/observer/observer_display_lifecycle.dart';
import 'internal/extensions/extensions_global_key.dart';

class UEMarker extends StatefulWidget {
  // region - attributes
  final Widget child;

  // endregion

  // region - constructors
  const UEMarker({super.key, required this.child});

  // endregion

  // region - override
  @override
  State<UEMarker> createState() => UEMarkerState();
// endregion
}

class UEMarkerState extends State<UEMarker> {
  // region - attributes
  late final _UEMarkerGlobalKey _widgetKey;
  late bool _enableMasking;
  late bool _needsRendering; // Track if the widget needs to be re-rendered
  late Rect _previousLocation; // Track the previous location for comparison
  // endregion

  // region - getters
  UEMarkerLocation get locationInGlobalScope {

    return UEMarkerLocation(
      uuid: _widgetKey.uuid,
      rect: mounted ? _enableMasking ? _widgetKey.globalPaintBounds : Rect.zero : Rect.zero);
  }
  // endregion

  // region - override
  @override
  void initState() {
    super.initState();

    _widgetKey = _UEMarkerGlobalKey();
    _enableMasking = true;
    _needsRendering = false;
    _previousLocation = Rect.zero;

    debugPrint("_globalKey ${_widgetKey.toString()} - created");

    UEMarkerMonitorController.instance.register(this);
  }

  @override
  void didUpdateWidget(covariant UEMarker oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    debugPrint("_globalKey ${_widgetKey.toString()} - destroyed");
    UEMarkerMonitorController.instance.deregister(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Rect currentLocation = locationInGlobalScope.rect;

    // Check if the location has changed
    if (currentLocation != _previousLocation) {
      _needsRendering = true;
      _previousLocation = currentLocation;
    }

    // Reset the flag if necessary
    if (_needsRendering) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _needsRendering = false;
      });
    }

    return DisplayLifecycleObserver(
      key: _widgetKey,
      onFocusGained: () {
        _enableMasking = true;
      },
      onFocusLost: () {
        // if (mounted) {
          _enableMasking = false;
        // }
      },
      child: widget.child,
    );
  }
// endregion
}

class _UEMarkerGlobalKey extends GlobalKey<UEMarkerState> {
  final String uuid;

  _UEMarkerGlobalKey()
      : uuid = _generateUUID(),
        super.constructor();

  static String _generateUUID() {
    final Random random = Random();
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < 32; i++) {
      int randomInt = random.nextInt(16);
      buffer.write(randomInt.toRadixString(16));
    }
    return buffer.toString();
  }

  @override
  String toString() =>
      'UEMarkerGlobalKey(uuid: $uuid, key: ${super.toString()})';
}
