/// Base class for all failures/errors in the application.
abstract class Failure implements Exception {
  const Failure({
    required this.message,
    this.code,
  });

  /// Human-readable error message
  final String message;

  /// Error code for programmatic handling
  final String? code;

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Generic failure for unknown errors
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unknown error occurred',
    super.code = 'unknown',
  });
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Network error occurred',
    super.code = 'network_error',
  });
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred',
    super.code = 'server_error',
  });
}

/// Local cache/database failures
class LocalCacheFailure extends Failure {
  const LocalCacheFailure({
    super.message = 'Local cache error occurred',
    super.code = 'cache_error',
  });
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'validation_error',
  });
}

/// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found',
    super.code = 'not_found',
  });
}

/// Unauthorized failures
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized access',
    super.code = 'unauthorized',
  });
}
