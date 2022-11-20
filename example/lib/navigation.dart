import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'pages/home/home.dart';

class NavigationUtil {
  NavigationUtil._();

  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          name: "home",
          builder: (context, state) {
            return const HomePage();
          }),
    ],
  );

  static RouterDelegate<Object> get delegate => router.routerDelegate;
}

class RouteNames {
  RouteNames._();

  static const home = 'home';
}
