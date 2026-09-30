import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockups/core/network/api_client.dart';
import 'package:mockups/core/network/response_envelope_interceptor.dart';

void main() {
  test(
    'ResponseE entrega a los datasources únicamente el campo data',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));
      server.listen((request) async {
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode({
            'success': true,
            'message': 'Correcto',
            'data': [
              {'id': 1},
            ],
            'meta': null,
            'error': null,
          }),
        );
        await request.response.close();
      });

      final dio = Dio(
        BaseOptions(baseUrl: 'http://${server.address.address}:${server.port}'),
      )..interceptors.add(ResponseEnvelopeInterceptor());
      final client = ApiClient.withDio(dio);

      final response = await client.get<List<dynamic>>('/items');

      expect(response.data, [
        {'id': 1},
      ]);
    },
  );
}
