import 'package:flutter/material.dart';
import 'package:user_experior_example/utilities/app_assets.dart';
import 'package:user_experior_example/utilities/app_routes.dart';

class UIMainPage extends StatelessWidget {
  const UIMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(child: Text('ui main')),
        IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.login.description);
            },
            icon: Image.asset(AppAssets.rickMorty)),
      ],
    );
  }
}
