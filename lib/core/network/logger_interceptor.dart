import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor de logging que solo imprime en modo debug (`kDebugMode`).
///
/// Mantiene el output corto: método, ruta, status code y mensaje de error
/// resumido. No imprime cuerpos completos para evitar fugas de datos
/// sensibles (descripciones de denuncias, evidencias).
class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '→ ${options.method} ${options.uri}',
        name: 'LILA.api',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '← ${response.statusCode} ${response.requestOptions.uri}',
        name: 'LILA.api',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final status = err.response?.statusCode ?? '-';
      developer.log(
        '✗ $status ${err.requestOptions.method} '
        '${err.requestOptions.uri}  ::  ${err.message}',
        name: 'LILA.api',
        error: err.error,
      );
    }
    handler.next(err);
  }
}
