import 'package:flutter/material.dart';

/// Key which is used to identify the [RepaintBoundary]
final _ueRecordingWidgetKey = GlobalKey(debugLabel: 'ue_recording_widget');

class UERecordingWidget extends StatelessWidget {
  final Widget child;
  GlobalKey get _sk => _ueRecordingWidgetKey;

  const UERecordingWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) => RepaintBoundary(key: _sk, child: child);
}
