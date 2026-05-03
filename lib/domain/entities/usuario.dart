/// Entidad pura de dominio que representa a un usuario de LILA.
///
/// No depende de JSON ni de paquetes externos: contiene únicamente la
/// información que el resto de la aplicación necesita para razonar sobre
/// un usuario.
class Usuario {
  final String idUsuario;
  final String? cedula;
  final String? telefono;
  final DateTime? fechaRegistro;
  final bool estado;
  final String? sexoBiologico;
  final String? orientacionGenero;
  final String? correoEmail;
  final String? tipoUsuario;
  final String? deviceId;

  const Usuario({
    required this.idUsuario,
    this.cedula,
    this.telefono,
    this.fechaRegistro,
    this.estado = true,
    this.sexoBiologico,
    this.orientacionGenero,
    this.correoEmail,
    this.tipoUsuario,
    this.deviceId,
  });
}
