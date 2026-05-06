import '../../data/models/usuario_model.dart';

/// Contrato del repositorio de usuarios.
///
/// La capa de datos lo implementa contra el endpoint HTTP, mientras
/// que los ViewModel dependen únicamente de esta interfaz.
abstract class UsuarioRepository {
  /// Crea un usuario en el backend a partir del `deviceId` actual.
  /// Devuelve el usuario completo (con su `idUsuario` UUID generado).
  Future<UsuarioModel> registerWithDevice({
    required String deviceId,
    String? cedula,
    String? telefono,
    String? sexoBiologico,
    String? orientacionGenero,
    String? correoEmail,
    String? tipoUsuario,
  });

  /// Lista todos los usuarios — útil principalmente para depuración.
  Future<List<UsuarioModel>> fetchAll();
}
