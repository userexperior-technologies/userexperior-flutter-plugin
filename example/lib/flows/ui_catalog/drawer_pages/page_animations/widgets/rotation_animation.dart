import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior/user_experior.dart';
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_animations/provider/animation_provider.dart';

class RotationAnimation extends StatefulWidget {
  const RotationAnimation({super.key});

  @override
  State<RotationAnimation> createState() => _RotationAnimationState();
}

class _RotationAnimationState extends State<RotationAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotateController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _animation =
        CurvedAnimation(parent: _rotateController, curve: Curves.linear);
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UEMarker(
      child: Positioned(
        top: 10,
        left: 10,
        child: Consumer<AnimationProvider>(
            builder: (context, animationProvider, child) {
          animationProvider.rotateAnimation
              ? _rotateController.repeat()
              : _rotateController.stop();
          return RotationTransition(
              turns: _animation,
              child: const Icon(
                Icons.accessibility_rounded,
                size: 150,
                color: Colors.amber,
              ));
        }),
      ),
    );
  }
}
