// Path: providers\app_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application-level providers.
/// 
/// This file contains providers that are used across the entire application.
/// Feature-specific providers should be defined within their respective features.

/// Provider for application initialization status
final appInitializationProvider = StateProvider<bool>((ref) => false);

/// Provider for tracking if the app is in debug mode
final debugModeProvider = Provider<bool>((ref) {
  var isDebug = false;
  assert(() {
    isDebug = true;
    return true;
  }());
  return isDebug;
});
