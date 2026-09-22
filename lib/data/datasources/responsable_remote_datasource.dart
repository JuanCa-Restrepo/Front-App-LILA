import '../../core/constants/api_constants.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/network/api_client.dart';
import '../models/responsable_model.dart';

class ResponsableRemoteDatasource {
  final ApiClient _client;

  const ResponsableRemoteDatasource(this._client);

  /// `GET /responsables` — lista todos los responsables.
  Future<List<ResponsableModel>> fetchAll() async {
    final response = await _client.get<List<dynamic>>(
      ApiConstants.responsables,
    );
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(ResponsableModel.fromJson)
        .toList(growable: false);
  }

  /// `GET /responsables/:id`.
  Future<ResponsableModel> fetchById(String idResponsable) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiConstants.responsables}/$idResponsable',
    );
    final data = response.data;
    if (data == null) {
      throw const UnexpectedException(
        'Respuesta vacía al obtener responsable.',
      );
    }
    return ResponsableModel.fromJson(data);
  }
}
