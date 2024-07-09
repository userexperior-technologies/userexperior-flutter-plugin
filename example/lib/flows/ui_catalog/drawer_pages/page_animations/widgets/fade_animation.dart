import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior/user_experior.dart';
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_animations/provider/animation_provider.dart';

class FadeAnimation extends StatefulWidget {
  const FadeAnimation({super.key});

  @override
  State<FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _opacityController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _opacityController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 10,
      child: Consumer<AnimationProvider>(
        builder: (context, animationProvider, child) {
          animationProvider.opacityAnimation
              ? _opacityController.repeat(reverse: true)
              : _opacityController.stop();
          return FadeTransition(
            opacity: _animation,
            child: const Icon(
              Icons.music_note,
              size: 150,
              color: Colors.green,
            ),
          );
        },
      ),
    );
  }
}
