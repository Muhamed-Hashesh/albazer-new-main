import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      Navigator.pushNamed(
        this,
        routeName,
        arguments: arguments,
      );
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) =>
      Navigator.pushReplacementNamed(
        this,
        routeName,
        arguments: arguments,
      );
  Future<T?> pushNamedAndRemoveUntil<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) =>
      Navigator.pushNamedAndRemoveUntil(
        this,
        routeName,
        (route) => false,
        arguments: arguments,
      );
  void pop<T extends Object?>([T? result]) => Navigator.pop(
        this,
        result,
      );
  bool canPop() => Navigator.canPop(
        this,
      );
  void popUntil() => Navigator.popUntil(
        this,
        (route) => false,
      );
}
