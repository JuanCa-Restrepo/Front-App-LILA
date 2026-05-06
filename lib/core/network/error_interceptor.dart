import 'package:dio/dio.dart';

import '../errors/app_exceptions.dart';

/// Traduce cualquier `DioException` que salga del cliente HTTP a una
/// `AppException` del dominio de la app.
///
/// Así los ViewModel **nunca** ven detalles de Dio: solo capturan
/// `AppException` y muestran `error.message` en la UI.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = _mapToAppException(err);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mapped,
        message: mapped.message,
      ),
    );
  }

  AppException _mapToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          'Tiempo de espera agotado. Verifica tu conexión.',
        );

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return NetworkException(
          'No se pudo conectar al servidor. ${err.message ?? ''}'.trim(),
        );

      case DioExceptionType.cancel:
        return const NetworkException('Petición cancelada.');

      case DioExceptionType.badCertificate:
        return const NetworkException('Certificado SSL inválido.');

      case DioExceptionType.badResponse:
        return _mapBadResponse(err.response);
    }
  }

  AppException _mapBadResponse(Response? response) {
    final status = response?.statusCode;
    final body = response?.data;

    final backendMessage = _extractBackendMessage(body);

    if (status == 404) {
      return NotFoundException(backendMessage ?? 'Recurso no encontrado.');
    }
    if (status != null && status >= 400 && status < 500) {
      return ValidationException(backendMessage ?? 'Datos inválidos.');
    }
    return ServerException(
      backendMessage ?? 'Error interno del servidor.',
      statusCode: status,
    );
  }

  /// El backend de LILA usa indistintamente `error`, `message` o `mensaje`
  /// para describir el fallo. Probamos en ese orden.
  String? _extractBackendMessage(dynamic body) {
    if (body is Map) {
      final candidates = [body['error'], body['message'], body['mensaje']];
      for (final value in candidates) {
        if (value is String && value.trim().isNotEmpty) return value;
      }
    }
    if (body is String && body.trim().isNotEmpty) return body;
    return null;
  }
}
