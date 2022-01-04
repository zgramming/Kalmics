import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class GlobalNavigation {
  Future<void> pushNamed({
    required String routeName,
    Object? arguments,
  }) async {
    await navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<void> pushNamedAndRemoveUntil({
    required String routeName,
    required bool Function(Route<dynamic> route) predicate,
    Object? arguments,
  }) async {
    await navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  void popUntill({
    required bool Function(Route<dynamic> route) predicate,
  }) {
    navigatorKey.currentState?.popUntil(predicate);
  }

  void pop() {
    navigatorKey.currentState?.pop();
  }
}

final globalNavigation = GlobalNavigation();
