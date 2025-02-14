import 'package:flutter/material.dart';

class UERecordingWidget extends StatelessWidget {
  final Widget child;

  const UERecordingWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) => RepaintBoundary(child: child);
}
