import 'package:flutter/material.dart';

import 'internal/user_experior_platform_interface.dart';

class UEMonitoredApp extends MaterialApp {
  static VoidCallback get _onPreNavigation => () {
        debugPrint('Pre-navigation ');
        UserExperiorPlatform.instance.updateTransitioningState(true);
      };

  /// Creates a Monitored MaterialApp.
  ///
  /// At least one of [home], [routes], [onGenerateRoute], or [builder] must be
  /// non-null. If only [routes] is given, it must include an entry for the
  /// [Navigator.defaultRouteName] (`/`), since that is the route used when the
  /// application is launched with an intent that specifies an otherwise
  /// unsupported route.
  ///
  /// This class creates an instance of [WidgetsApp].
  UEMonitoredApp(
      {super.key,
      super.navigatorKey,
      super.scaffoldMessengerKey,
      super.home,
      super.routes,
      String? initialRoute,
      RouteFactory? onGenerateRoute,
      InitialRouteListFactory? onGenerateInitialRoutes,
      RouteFactory? onUnknownRoute,
      List<NavigatorObserver> navigatorObservers = const <NavigatorObserver>[],
      super.builder,
      super.title,
      super.onGenerateTitle,
      super.color,
      super.theme,
      super.darkTheme,
      super.highContrastTheme,
      super.highContrastDarkTheme,
      ThemeMode super.themeMode,
      super.themeAnimationDuration,
      super.themeAnimationCurve,
      super.locale,
      super.localizationsDelegates,
      super.localeListResolutionCallback,
      super.localeResolutionCallback,
      super.supportedLocales,
      super.debugShowMaterialGrid,
      super.showPerformanceOverlay,
      super.checkerboardRasterCacheImages,
      super.checkerboardOffscreenLayers,
      super.showSemanticsDebugger,
      super.debugShowCheckedModeBanner,
      Map<LogicalKeySet, Intent>? super.shortcuts,
      super.actions,
      super.restorationScopeId,
      super.scrollBehavior,
      bool useInheritedMediaQuery = false})
      : super(
          initialRoute: () {
            _onPreNavigation();
            return initialRoute;
          }(),
          onGenerateRoute: (RouteSettings settings) {
            // Pre-navigation action
            _onPreNavigation();
            // Call the developer's onGenerateRoute if provided
            if (onGenerateRoute != null) {
              return onGenerateRoute(settings);
            }
            // Default route handling
            return null;
          },
          onGenerateInitialRoutes: onGenerateInitialRoutes != null
              ? (initialRoute) {
                  _onPreNavigation();
                  return onGenerateInitialRoutes(initialRoute);
                }
              : null,
          onUnknownRoute: onUnknownRoute != null
              ? (RouteSettings settings) {
                  _onPreNavigation();
                  return onUnknownRoute(settings);
                }
              : null,
          navigatorObservers: [
            _UENavigationObserver(),
            ...navigatorObservers,
          ],
        );
}

typedef _PreNavigationCallback = void Function(RouteSettings settings);
typedef _PostNavigationCallback = void Function(Route<dynamic>? route, Route<dynamic>? previousRoute);
typedef _PostNavigationAction = void Function(ModalRoute<dynamic>? route);

class _UENavigationObserver extends NavigatorObserver {

  static VoidCallback get _onPreNavigation => () {
    debugPrint('Pre-navigation ');
    UserExperiorPlatform.instance.updateTransitioningState(true);
  };
  static _PostNavigationCallback get onPostNavigation => (route, previousRoute) {
        debugPrint(
            'Post-navigation from: ${previousRoute?.settings.name} to ${route?.settings.name}');
        UserExperiorPlatform.instance.updateTransitioningState(false);
      };
  static _PostNavigationAction get onPostNavigationAct => (route) {
    debugPrint(
        'Post-navigation to ${route?.settings.name}');
    UserExperiorPlatform.instance.updateTransitioningState(false);
  };
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is ModalRoute) {
      _onPreNavigation.call();
    }
    super.didPush(route, previousRoute);
    if (route is ModalRoute) {
      _addAnimationListener(route);
    } else {
      onPostNavigation(route, previousRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route is ModalRoute) {
      _addAnimationListener(route);
    } else {
      onPostNavigation(route, previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _onPreNavigation.call();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null && newRoute is ModalRoute) {
      _addAnimationListener(newRoute);
    } else {
      onPostNavigation(newRoute, oldRoute);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (route is ModalRoute) {
      _addAnimationListener(route);
    } else {
      onPostNavigation(route, previousRoute);
    }
  }

  void _addAnimationListener(ModalRoute<dynamic> route) {
    final animation = route.animation;

    late void Function(AnimationStatus) listener;

    listener = (AnimationStatus status) {
      if ((status == AnimationStatus.completed) ||
          (status == AnimationStatus.dismissed)) {
        onPostNavigationAct(route);
        animation?.removeStatusListener(listener);
      }
    };

    if (animation?.status == AnimationStatus.completed) {
      onPostNavigationAct(route);
    } else {
      animation?.addStatusListener(listener);
    }
  }
}
