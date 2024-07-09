import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior_example/flows/ui_utility/screen_login/provider/login_provider.dart';
import 'package:user_experior_example/utilities/app_assets.dart';

class RickMortyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RickMortyAppBar({super.key});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        AppAssets.rockAndMortyLogo,
        fit: BoxFit.contain,
        height: 70,
      ),
      centerTitle: true,
      leading: Navigator.of(context).canPop()
          ? IconButton(
              icon: const BackButtonIcon(),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : const SizedBox(),
      actions: [
        if (!Navigator.of(context).canPop())
          IconButton(
              onPressed: () {
                Provider.of<LoginProvider>(context, listen: false)
                    .logout(context);
              },
              icon: const Icon(Icons.logout_rounded)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
