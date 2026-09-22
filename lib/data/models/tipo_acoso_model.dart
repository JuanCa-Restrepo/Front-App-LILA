/// Catálogo de tipos de acoso disponibles en el sistema.
class TipoAcosoModel {
  final int idTipoAcoso;
  final String descripcion;

  const TipoAcosoModel({
    required this.idTipoAcoso,
    required this.descripcion,
  });

  factory TipoAcosoModel.fromJson(Map<String, dynamic> json) {
    return TipoAcosoModel(
      idTipoAcoso: (json['idTipoAcoso'] as num).toInt(),
      descripcion: json['descripcion']?.toString() ?? '',
    );
  }
}
