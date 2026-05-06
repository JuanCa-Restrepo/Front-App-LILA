import '../../core/constants/api_constants.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/network/api_client.dart';
import '../models/caso_model.dart';

class CasoRemoteDatasource {
  final ApiClient _client;

  const CasoRemoteDatasource(this._client);

  /// `POST /casos` — crea un caso. Devuelve el modelo de respuesta del
  /// backend con el `codigoCaso` plano y el mensaje de confirmación.
  Future<CreatedCaseModel> create({
    required String idUsuario,
    required int idTipoAcoso,
    String? idResponsable,
    required bool pasoInstitucion,
    String? descripcion,
  }) async {
    final body = CasoModel.toCreateJson(
      idUsuario: idUsuario,
      idTipoAcoso: idTipoAcoso,
      idResponsable: idResponsable,
      pasoInstitucion: pasoInstitucion,
      descripcion: descripcion,
    );

    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.casos,
      data: body,
    );
    final data = response.data;
    if (data == null) {
      throw const UnexpectedException(
        'El servidor no devolvió datos al crear el caso.',
      );
    }
    return CreatedCaseModel.fromJson(data);
  }

  /// `GET /casos`.
  Future<List<CasoModel>> fetchAll() async {
    final response = await _client.get<List<dynamic>>(ApiConstants.casos);
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(CasoModel.fromJson)
        .toList(growable: false);
  }

  /// `GET /casos/:id`.
  Future<CasoModel> fetchById(String idCaso) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiConstants.casos}/$idCaso',
    );
    final data = response.data;
    if (data == null) {
      throw const UnexpectedException('Respuesta vacía al obtener caso.');
    }
    return CasoModel.fromJson(data);
  }

  /// `GET /casos/codigo/:codigo` — el código viaja en plano (`#XX-XXXXX`).
  Future<CasoModel> fetchByCodigo(String codigoCaso) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiConstants.casos}/codigo/${Uri.encodeComponent(codigoCaso)}',
    );
    final data = response.data;
    if (data == null) {
      throw const UnexpectedException(
        'Respuesta vacía al obtener caso por código.',
      );
    }
    return CasoModel.fromJson(data);
  }
}
