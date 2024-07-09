import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior/user_experior.dart';
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_animations/provider/animation_provider.dart';

class ScaleAnimation extends StatefulWidget {
  const ScaleAnimation({super.key});

  @override
  State<ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _sizeController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _sizeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _sizeController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: Consumer<AnimationProvider>(
          builder: (context, animationProvider, child) {
        animationProvider.sizeAnimation
            ? _sizeController.repeat(reverse: true)
            : _sizeController.stop();
        return ScaleTransition(
          scale: _animation,
          child: const Icon(
            Icons.star,
            size: 150,
            color: Colors.yellow,
          ),
        );
      }),
    );
  }
}
