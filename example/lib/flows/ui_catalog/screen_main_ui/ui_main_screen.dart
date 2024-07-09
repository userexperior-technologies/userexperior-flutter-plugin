import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior/user_experior.dart';
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_animations/provider/animation_provider.dart';
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_input_field/input_field_provider/input_field_provider.dart';

import 'provider/ui_main_provider.dart';
import 'widgets/app_drawer.dart';

class UiMainScreen extends StatelessWidget {
  UiMainScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UiMainProvider()),
        ChangeNotifierProvider(create: (context) => InputFieldProvider()),
        ChangeNotifierProvider(create: (context) => AnimationProvider()),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('UI Demo'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              if (_scaffoldKey.currentState?.isDrawerOpen == false) {
                UserExperior.instance.updateTransitioningState(true);
              }
              _scaffoldKey.currentState?.openDrawer();

            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                if (_scaffoldKey.currentState?.isEndDrawerOpen == false) {
                  UserExperior.instance.updateTransitioningState(true);
                }
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Consumer<UiMainProvider>(
            builder: (context, mainProvider, child) {
              return mainProvider.selectedPage.page;
            },
          ),
        ),
        drawer: const AppDrawer(),
        onDrawerChanged: (bool isOpened) {
          UserExperior.instance.updateTransitioningState(false);
        },
        endDrawer: const AppDrawer(),
        onEndDrawerChanged: (bool isOpened) {
          UserExperior.instance.updateTransitioningState(false);
        },
      ),
    );
  }
}
