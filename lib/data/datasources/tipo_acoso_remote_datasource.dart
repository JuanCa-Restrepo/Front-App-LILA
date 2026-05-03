import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/tipo_acoso_model.dart';

class TipoAcosoRemoteDatasource {
  final ApiClient _client;

  const TipoAcosoRemoteDatasource(this._client);

  /// `GET /tipos-acoso` — catálogo completo.
  Future<List<TipoAcosoModel>> fetchAll() async {
    final response = await _client.get<List<dynamic>>(ApiConstants.tiposAcoso);
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(TipoAcosoModel.fromJson)
        .toList(growable: false);
  }
}
