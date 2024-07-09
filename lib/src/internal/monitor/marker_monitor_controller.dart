import 'package:flutter/material.dart';

import '../../ue_marker.dart';
import 'marker_location.dart';

class UEMarkerMonitorController {
  // region - singleton
  static UEMarkerMonitorController _instance = UEMarkerMonitorController();

  /// The default instance of [UEMarkerMonitorController] to use.
  ///
  /// Defaults to [UEMarkerMonitorController].
  static UEMarkerMonitorController get instance => _instance;

  /// Subclasses implementations should set this with their own
  /// Subclass that extends [UEMarkerMonitorController] when they register themselves.
  static set instance(UEMarkerMonitorController instance) =>
      _instance = instance;

  // endregion

  // region - attributes
  final List<UEMarkerState> _displayMarkers;

  // endregion

  // region - constructor
  UEMarkerMonitorController(
      {List<UEMarkerState> states = const <UEMarkerState>[]})
      : _displayMarkers = List.from(states);

  // endregion

  // region - api
  void register(UEMarkerState state) {
    if (!_displayMarkers.contains(state)) {
      _displayMarkers.add(state);
    }
  }

  void deregister(UEMarkerState state) {
    if (_displayMarkers.contains(state)) {
      _displayMarkers.remove(state);
    }
  }

  // endregion

  List<UEMarkerLocation> getMarkerLocations() {
    final a =
        _displayMarkers.map((state) => state.locationInGlobalScope).toList();
    for (var m in a) {
      debugPrint(m.toString());
    }
    return a;
  }
}
