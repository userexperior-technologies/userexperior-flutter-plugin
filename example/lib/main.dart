import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior/user_experior.dart';

import 'characters/provider/characters_provider.dart';
import 'dependency_injection/injectable.dart';
import 'flows/ui_catalog/lib_ui_catalog.dart';
import 'flows/ui_utility/lib_ui_utility.dart';
import 'flows/ui_utility/provider/character_details_provider.dart';
import 'flows/ui_utility/screen_login/provider/login_provider.dart';
import 'splash/splash_screen.dart';
import 'utilities/app_routes.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  runApp(const UEExampleApp());
}

class UEExampleApp extends StatelessWidget {

  const UEExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return dependencyProvider<CharacterProvider>();
        }),
        ChangeNotifierProvider(create: (_) {
          return dependencyProvider<LoginProvider>();
        }),
        ChangeNotifierProvider(create: (_) {
          return dependencyProvider<CharacterDetailsProvider>();
        }),
      ],
      child: UEMonitoredApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.base.description,
        onGenerateRoute: (settings) =>
            MaterialPageRoute(builder: (context) => const SplashScreen()),
        routes: {
          AppRoutes.base.description: (context) => const SplashScreen(),
          AppRoutes.login.description: (context) => const LoginScreen(),
          AppRoutes.utilityEpisodes.description: (context) =>
              const EpisodesScreen(),
          AppRoutes.utilityCharacters.description: (context) =>
              const CharactersScreen(),
          AppRoutes.utilityCharacterDetails.description: (context) =>
              const CharacterDetailsScreen(),
          AppRoutes.uiCatalog.description: (context) => UiMainScreen(),
        },
        navigatorObservers: [routeObserver],
      ),
    );
  }
}
