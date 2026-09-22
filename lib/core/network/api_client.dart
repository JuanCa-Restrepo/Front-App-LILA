import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../errors/app_exceptions.dart';
import 'error_interceptor.dart';
import 'logger_interceptor.dart';

/// Wrapper sobre Dio. Centraliza la configuración (baseUrl, timeouts,
/// interceptores) y desempaqueta automáticamente los errores: cada
/// método público lanza directamente `AppException`, nunca `DioException`.
///
/// Como la app no maneja autenticación, no añadimos interceptor de
/// Bearer token: el orden es **logger → error mapper**.
class ApiClient {
  final Dio _dio;

  ApiClient._(this._dio);

  /// Constructor por defecto. Se instancia una sola vez en `app.dart`.
  factory ApiClient.create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      LoggerInterceptor(),
      ErrorInterceptor(),
    ]);

    return ApiClient._(dio);
  }

  /// Constructor que acepta un `Dio` ya configurado. Útil para tests.
  factory ApiClient.withDio(Dio dio) => ApiClient._(dio);

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _exec(() => _dio.get<T>(path, queryParameters: queryParameters));
  }

  Future<Response<T>> post<T>(String path, {Object? data}) {
    return _exec(() => _dio.post<T>(path, data: data));
  }

  Future<Response<T>> put<T>(String path, {Object? data}) {
    return _exec(() => _dio.put<T>(path, data: data));
  }

  Future<Response<T>> delete<T>(String path) {
    return _exec(() => _dio.delete<T>(path));
  }

  /// Ejecuta `request` y traduce cualquier `DioException` a la
  /// `AppException` que ya colocó el `ErrorInterceptor`.
  Future<T> _exec<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw UnexpectedException(e.message ?? 'Error inesperado.');
    }
  }
}
