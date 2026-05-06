import '../../core/constants/api_constants.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/network/api_client.dart';
import '../models/usuario_model.dart';

/// Acceso HTTP directo a `/api/usuarios`.
class UsuarioRemoteDatasource {
  final ApiClient _client;

  const UsuarioRemoteDatasource(this._client);

  /// `POST /usuarios` — crea el usuario y retorna la entidad completa
  /// con el `idUsuario` UUID generado por el backend.
  Future<UsuarioModel> create({
    required String deviceId,
    String? cedula,
    String? telefono,
    String? sexoBiologico,
    String? orientacionGenero,
    String? correoEmail,
    String? tipoUsuario,
  }) async {
    final body = UsuarioModel(
      // El backend ignora idUsuario en el create, pero la entidad lo exige.
      idUsuario: '',
      deviceId: deviceId,
      cedula: cedula,
      telefono: telefono,
      sexoBiologico: sexoBiologico,
      orientacionGenero: orientacionGenero,
      correoEmail: correoEmail,
      tipoUsuario: tipoUsuario,
    ).toCreateJson();

    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.usuarios,
      data: body,
    );

    final data = response.data;
    if (data == null) {
      throw const UnexpectedException(
        'El servidor no devolvió datos al crear el usuario.',
      );
    }
    return UsuarioModel.fromJson(data);
  }

  /// `GET /usuarios` — lista todos los usuarios (uso interno/depuración).
  Future<List<UsuarioModel>> fetchAll() async {
    final response = await _client.get<List<dynamic>>(ApiConstants.usuarios);
    final data = response.data ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(UsuarioModel.fromJson)
        .toList(growable: false);
  }
}
