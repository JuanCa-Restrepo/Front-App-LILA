import 'package:dio/dio.dart';

/// Desempaqueta el contrato uniforme `ResponseE` del backend.
///
/// El servidor responde `{ success, message, data, ... }`, mientras que los
/// datasources trabajan directamente con la entidad o lista contenida en
/// `data`. Las respuestas que no tengan esa forma se conservan intactas.
class ResponseEnvelopeInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final body = response.data;
    if (body is Map &&
        body.containsKey('success') &&
        body.containsKey('data')) {
      response.data = body['data'];
    }
    handler.next(response);
  }
}
