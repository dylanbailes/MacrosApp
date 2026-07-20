import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'app_providers.dart';

/// Riverpod observer for logging state changes (useful for debugging)
class AppRiverpodObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    // Uncomment for debugging:
    // print('[Riverpod] ${provider.name ?? provider.runtimeType}: $previousValue -> $newValue');
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    // Uncomment for debugging:
    // print('[Riverpod] Disposed: ${provider.name ?? provider.runtimeType}');
  }
}
