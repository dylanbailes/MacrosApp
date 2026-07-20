import 'package:flutter/material.dart';

/// Extension methods on BuildContext for convenient access to theme and navigation.
extension BuildContextExtensions on BuildContext {
  /// Get the theme data
  ThemeData get theme => Theme.of(this);

  /// Get the text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get the color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get the media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get the screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get the screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get the screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Check if the screen is narrow (mobile)
  bool get isNarrow => screenWidth < 600;

  /// Check if the screen is medium (tablet)
  bool get isMedium => screenWidth >= 600 && screenWidth < 1200;

  /// Check if the screen is wide (desktop)
  bool get isWide => screenWidth >= 1200;

  /// Show a snackbar
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Navigate back
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
}
