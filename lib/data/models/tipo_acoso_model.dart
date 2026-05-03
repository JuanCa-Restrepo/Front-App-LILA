import '../../domain/entities/tipo_acoso.dart';

class TipoAcosoModel extends TipoAcoso {
  const TipoAcosoModel({
    required super.idTipoAcoso,
    required super.descripcion,
  });

  factory TipoAcosoModel.fromJson(Map<String, dynamic> json) {
    return TipoAcosoModel(
      idTipoAcoso: (json['idTipoAcoso'] as num).toInt(),
      descripcion: json['descripcion']?.toString() ?? '',
    );
  }
}
