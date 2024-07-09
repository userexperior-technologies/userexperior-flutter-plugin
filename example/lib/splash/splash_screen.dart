import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:user_experior/user_experior.dart';
import 'package:user_experior_example/utilities/app_routes.dart';

import '../utilities/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late UserExperior _userExperiorPlugin;

  @override
  void initState() {
    _userExperiorPlugin = UserExperior();

    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userExperiorPlugin.startRecording(AppConstants.userExperiorKey);

    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset('lib/assets/animations/splash.json',
              width: double.infinity,
              height: double.infinity,
              controller: _controller, onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward().whenCompleteOrCancel(() {
                Timer(const Duration(milliseconds: 200), () {
                  _navigateToNextScreen();
                });
              });
          }),
        ],
      ),
    );
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.uiCatalog.description);
    // final int pathNum = Random().nextInt(100) % 2;
    // if (pathNum == 0) {
    //   Navigator.of(context).pushReplacementNamed(AppRoutes.login.description);
    // } else {
    //   Navigator.of(context)
    //       .pushReplacementNamed(AppRoutes.uiCatalog.description);
    // }
  }
}
