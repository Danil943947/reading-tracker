sealed class ApiException implements Exception {
  const ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

final class NoConnectionException extends ApiException {
  const NoConnectionException() : super('No connection. Try again.');
}

final class UnauthorizedException extends ApiException {
  const UnauthorizedException() : super('Session expired. Sign in again.');
}

final class NotFoundException extends ApiException {
  const NotFoundException() : super('This item is no longer available.');
}

final class BadResponseException extends ApiException {
  const BadResponseException(super.message);
}

final class ServerException extends ApiException {
  const ServerException(this.status) : super('Server error ($status). Try again.');
  final int status;
}

final class RequestException extends ApiException {
  const RequestException(super.message);
}
