/// Catálogo de tipos de acoso disponibles en el sistema.
class TipoAcosoModel {
  final int idTipoAcoso;
  final String descripcion;

  const TipoAcosoModel({required this.idTipoAcoso, required this.descripcion});

  factory TipoAcosoModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['idTipoAcoso'] ?? json['TipoAcosoID'];
    final id = rawId is num
        ? rawId.toInt()
        : int.tryParse(rawId?.toString() ?? '');
    if (id == null) {
      throw const FormatException(
        'La respuesta de tipos de acoso no contiene un identificador válido.',
      );
    }

    return TipoAcosoModel(
      idTipoAcoso: id,
      descripcion: (json['descripcion'] ?? json['TipoAcoso'])?.toString() ?? '',
    );
  }
}
