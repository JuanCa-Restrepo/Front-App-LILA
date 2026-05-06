import '../../domain/repositories/usuario_repository.dart';
import '../datasources/usuario_remote_datasource.dart';
import '../models/usuario_model.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioRemoteDatasource _remote;

  const UsuarioRepositoryImpl(this._remote);

  @override
  Future<UsuarioModel> registerWithDevice({
    required String deviceId,
    String? cedula,
    String? telefono,
    String? sexoBiologico,
    String? orientacionGenero,
    String? correoEmail,
    String? tipoUsuario,
  }) {
    return _remote.create(
      deviceId: deviceId,
      cedula: cedula,
      telefono: telefono,
      sexoBiologico: sexoBiologico,
      orientacionGenero: orientacionGenero,
      correoEmail: correoEmail,
      tipoUsuario: tipoUsuario,
    );
  }

  @override
  Future<List<UsuarioModel>> fetchAll() => _remote.fetchAll();
}
