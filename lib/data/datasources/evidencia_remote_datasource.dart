import '../../core/constants/api_constants.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/network/api_client.dart';
import '../models/evidencia_model.dart';

class EvidenciaRemoteDatasource {
  final ApiClient _client;

  const EvidenciaRemoteDatasource(this._client);

  /// `POST /evidencias` — registra la URL ya alojada (Google Drive).
  Future<EvidenciaModel> create({
    required String idCaso,
    required String tipoArchivo,
    required String urlArchivo,
  }) async {
    final body = EvidenciaModel.toCreateJson(
      idCaso: idCaso,
      tipoArchivo: tipoArchivo,
      urlArchivo: urlArchivo,
    );

    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.evidencias,
      data: body,
    );
    final data = response.data;
    if (data == null) {
      throw const UnexpectedException(
        'El servidor no devolvió datos al crear la evidencia.',
      );
    }
    return EvidenciaModel.fromJson(data);
  }

  /// `GET /evidencias/caso/:idCaso`.
  Future<List<EvidenciaModel>> fetchByCase(String idCaso) async {
    final response = await _client.get<List<dynamic>>(
      '${ApiConstants.evidencias}/caso/$idCaso',
    );
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(EvidenciaModel.fromJson)
        .toList(growable: false);
  }
}
