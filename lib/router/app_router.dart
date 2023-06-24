import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();
  static AppRouter router = AppRouter._();
  GlobalKey<NavigatorState> routerKey = GlobalKey<NavigatorState>();
  pushFunction(Widget widget) {
    routerKey.currentState?.push(MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  pushNamedFunction(String routeName, [Object? argument]) {
    routerKey.currentState?.pushNamed(routeName, arguments: argument);
  }

  pushWithReplacementFunction(Widget widget) {
    routerKey.currentState
        ?.pushReplacement(MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  pushNamedWithReplacementFunction(String routeName, [Object? argument]) {
    routerKey.currentState
        ?.pushReplacementNamed(routeName, arguments: argument);
  }

  pop() {
    routerKey.currentState?.pop();
  }
}
