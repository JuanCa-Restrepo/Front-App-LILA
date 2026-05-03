/// Caso reportado por un usuario.
///
/// El campo `codigoCaso` viaja en texto plano (no hasheado) y es lo que
/// la persona usa para consultar el estado posteriormente.
class Caso {
  final String idCaso;
  final String idUsuario;
  final int idTipoAcoso;
  final String? idResponsable;
  final String codigoCaso;
  final bool pasoInstitucion;
  final String? descripcion;
  final String estado;
  final DateTime? fechaReporte;
  final DateTime? fechaActualizacion;

  const Caso({
    required this.idCaso,
    required this.idUsuario,
    required this.idTipoAcoso,
    this.idResponsable,
    required this.codigoCaso,
    required this.pasoInstitucion,
    this.descripcion,
    this.estado = 'pendiente',
    this.fechaReporte,
    this.fechaActualizacion,
  });
}
