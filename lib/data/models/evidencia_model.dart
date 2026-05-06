/// Evidencia (archivo) adjunta a un caso.
///
/// `urlArchivo` apunta al recurso ya alojado en Google Drive — el
/// backend nunca recibe el binario, solo la URL pública resultante.
class EvidenciaModel {
  final String idEvidencia;
  final String idCaso;
  final String? tipoArchivo;
  final String urlArchivo;
  final DateTime? fechaSubida;

  const EvidenciaModel({
    required this.idEvidencia,
    required this.idCaso,
    this.tipoArchivo,
    required this.urlArchivo,
    this.fechaSubida,
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
