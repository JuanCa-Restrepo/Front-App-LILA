import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../datasources/usuario_remote_datasource.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioRemoteDatasource _remote;

  const UsuarioRepositoryImpl(this._remote);

  @override
  Future<Usuario> registerWithDevice({
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
  Future<List<Usuario>> fetchAll() => _remote.fetchAll();
}
