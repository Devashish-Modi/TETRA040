/// Application-level failures with optional underlying cause.
class AppException implements Exception {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  const AppException(this.message, {this.cause, this.stackTrace});

  @override
  String toString() =>
      cause == null ? 'AppException: $message' : 'AppException: $message ($cause)';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause, super.stackTrace});
}

class AuthException extends AppException {
  const AuthException(super.message, {super.cause, super.stackTrace});
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.cause, super.stackTrace});
}

class StorageException extends AppException {
  const StorageException(super.message, {super.cause, super.stackTrace});
}
