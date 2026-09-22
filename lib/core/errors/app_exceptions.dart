/// Excepciones que la capa de datos lanza hacia los ViewModel.
///
/// La UI nunca debería ver un `DioException` directamente: el cliente HTTP
/// las traduce a alguna de estas para que los ViewModel solo manejen
/// excepciones de la app.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => 'AppException($statusCode): $message';
}

/// Hay conexión pero el servidor respondió con un error (4xx/5xx).
class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

/// El cliente no logró conectar (sin internet, host caído, timeout).
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// El recurso solicitado no existe (404).
class NotFoundException extends AppException {
  const NotFoundException(super.message) : super(statusCode: 404);
}

/// Datos enviados inválidos según el backend (400).
class ValidationException extends AppException {
  const ValidationException(super.message) : super(statusCode: 400);
}

/// Error inesperado al parsear la respuesta o al ejecutar lógica interna.
class UnexpectedException extends AppException {
  const UnexpectedException(super.message);
}
