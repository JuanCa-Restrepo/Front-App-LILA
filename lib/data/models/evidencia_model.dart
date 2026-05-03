import '../../domain/entities/evidencia.dart';

class EvidenciaModel extends Evidencia {
  const EvidenciaModel({
    required super.idEvidencia,
    required super.idCaso,
    super.tipoArchivo,
    required super.urlArchivo,
    super.fechaSubida,
  });

  factory EvidenciaModel.fromJson(Map<String, dynamic> json) {
    return EvidenciaModel(
      idEvidencia: json['idEvidencia'] as String,
      idCaso: json['idCaso'] as String,
      tipoArchivo: json['tipoArchivo'] as String?,
      urlArchivo: json['urlArchivo']?.toString() ?? '',
      fechaSubida: _parseDate(json['fechaSubida']),
    );
  }

  /// Cuerpo para `POST /evidencias`.
  static Map<String, dynamic> toCreateJson({
    required String idCaso,
    required String tipoArchivo,
    required String urlArchivo,
  }) {
    return {
      'idCaso': idCaso,
      'tipoArchivo': tipoArchivo,
      'urlArchivo': urlArchivo,
    };
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }
}
