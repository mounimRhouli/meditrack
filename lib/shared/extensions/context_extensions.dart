// lib/shared/extensions/context_extensions.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ContextExtensions on BuildContext {
  /// Pushes a new route onto the navigator stack using GoRouter.
  Future<T?> pushNamed<T>(String routeName, {Object? extra}) {
    return GoRouter.of(this).pushNamed<T>(routeName, extra: extra);
  }

  /// Replaces the current route with a new one using GoRouter.
  Future<T?> pushReplacementNamed<T>(String routeName, {Object? extra}) {
    // Corrected: Only one generic type is needed here.
    return GoRouter.of(this).pushReplacementNamed<T>(routeName, extra: extra);
  }

  /// Pops the topmost route off the navigator stack.
  void pop<T>([T? result]) {
    GoRouter.of(this).pop<T>(result);
  }

  /// Gets the screen height.
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Gets the screen width.
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Gets the theme's text styles for easy access.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Gets the theme's color scheme for easy access.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}