import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../dtos/registro_caso_dto.dart';

class RegistroCasoRemoteDatasource {
  final ApiClient _client;

  const RegistroCasoRemoteDatasource(this._client);

  /// Registra en una sola operación la identidad del dispositivo y los datos
  /// de la persona afectada asociados a un caso que ya existe.
  Future<void> register(RegistroCasoDto dto) async {
    await _client.post<dynamic>(ApiConstants.registroCaso, data: dto.toJson());
  }
}
