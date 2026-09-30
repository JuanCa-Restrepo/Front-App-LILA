/// Único contrato enviado a `POST /registro-caso`.
///
/// Aunque el formulario obtiene estos valores en pasos diferentes, el backend
/// los recibe en una sola solicitud con dos objetos anidados: `usuario` e
/// `infoAfectado`.
class RegistroCasoDto {
  final String deviceId;
  final String idCaso;
  final String? cedula;
  final String? telefono;
  final String? correoEmail;
  final String? sexoBiologico;
  final String? orientacionGenero;
  final String? tipoUsuario;

  const RegistroCasoDto({
    required this.deviceId,
    required this.idCaso,
    this.cedula,
    this.telefono,
    this.correoEmail,
    this.sexoBiologico,
    this.orientacionGenero,
    this.tipoUsuario,
  });

  Map<String, dynamic> toJson() {
    return {
      'usuario': {
        'deviceId': deviceId,
        if (cedula != null) 'cedula': cedula,
        if (telefono != null) 'telefono': telefono,
        if (correoEmail != null) 'correoEmail': correoEmail,
      },
      'infoAfectado': {
        'idCaso': idCaso,
        if (sexoBiologico != null) 'sexoBiologico': sexoBiologico,
        if (orientacionGenero != null) 'orientacionGenero': orientacionGenero,
        if (tipoUsuario != null) 'tipoUsuario': tipoUsuario,
      },
    };
  }
}
