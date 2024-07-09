import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior/user_experior.dart';
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_animations/provider/animation_provider.dart';

class PositionAnimation extends StatefulWidget {
  const PositionAnimation({super.key});

  @override
  State<PositionAnimation> createState() => _PositionAnimationState();
}

class _PositionAnimationState extends State<PositionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _positionController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _positionController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation =
        CurvedAnimation(parent: _positionController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationProvider>(
        builder: (context, animationProvider, child) {
      animationProvider.positionAnimation
          ? _positionController.repeat(reverse: true)
          : _positionController.stop();

      return PositionedTransition(
        rect: RelativeRectTween(
          begin: RelativeRect.fromSize(
              const Rect.fromLTWH(0, 0, 0, 0), const Size(150, 150)),
          end: RelativeRect.fromSize(
              const Rect.fromLTWH(0, 250, 0, 0), const Size(150, 150)),
        ).animate(_animation),
        child: const Icon(
          Icons.sports_basketball,
          size: 150,
          color: Colors.orange,
        ),
      );
    });
  }
}
