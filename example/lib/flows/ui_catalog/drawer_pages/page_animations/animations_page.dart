import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_animations/provider/animation_provider.dart';
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_animations/widgets/fade_animation.dart';
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_animations/widgets/position_animation.dart';
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_animations/widgets/rotation_animation.dart';
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_animations/widgets/scale_animation.dart';

class AnimationsPage extends StatelessWidget {
  const AnimationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: const [
              SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
              ),
              RotationAnimation(),
              ScaleAnimation(),
              FadeAnimation(),
              PositionAnimation(),
            ],
          ),
        ),
        _buttonsRow(context),
      ],
    );
  }

  Widget _buttonsRow(BuildContext context) {
    final provider = Provider.of<AnimationProvider>(context);
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Change Size'),
          value: provider.sizeAnimation,
          onChanged: (value) {
            provider.toggleSizeAnimation(value);
          },
        ),
        SwitchListTile(
          title: const Text('Rotate'),
          value: provider.rotateAnimation,
          onChanged: (value) {
            provider.toggleRotateAnimation(value);
          },
        ),
        SwitchListTile(
          title: const Text('Move Between Spots'),
          value: provider.positionAnimation,
          onChanged: (value) {
            provider.togglePositionAnimation(value);
          },
        ),
        SwitchListTile(
          title: const Text('Change Opacity'),
          value: provider.opacityAnimation,
          onChanged: (value) {
            provider.toggleOpacityAnimation(value);
          },
        ),
      ],
    );
  }
}
