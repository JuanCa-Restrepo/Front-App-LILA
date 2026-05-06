/// Caso reportado por un usuario.
///
/// El campo `codigoCaso` viaja en texto plano (no hasheado) y es lo que
/// la persona usa para consultar el estado posteriormente.
class CasoModel {
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

  const CasoModel({
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

  factory CasoModel.fromJson(Map<String, dynamic> json) {
    return CasoModel(
      idCaso: json['idCaso'] as String,
      idUsuario: json['idUsuario'] as String,
      idTipoAcoso: (json['idTipoAcoso'] as num).toInt(),
      idResponsable: json['idResponsable'] as String?,
      codigoCaso: json['codigoCaso']?.toString() ?? '',
      pasoInstitucion: _toBool(json['pasoInstitucion']),
      descripcion: json['descripcion'] as String?,
      estado: json['estado']?.toString() ?? 'pendiente',
      fechaReporte: _parseDate(json['fechaReporte']),
      fechaActualizacion: _parseDate(json['fechaActualizacion']),
    );
  }

  /// Cuerpo para `POST /casos`.
  static Map<String, dynamic> toCreateJson({
    required String idUsuario,
    required int idTipoAcoso,
    String? idResponsable,
    required bool pasoInstitucion,
    String? descripcion,
  }) {
    return {
      'idUsuario': idUsuario,
      'idTipoAcoso': idTipoAcoso,
      if (idResponsable != null) 'idResponsable': idResponsable,
      'pasoInstitucion': pasoInstitucion,
      if (descripcion != null) 'descripcion': descripcion,
    };
  }

  static bool _toBool(dynamic raw) {
    if (raw is bool) return raw;
    if (raw is num) return raw != 0;
    final asString = raw?.toString().toLowerCase();
    return asString == 'true' || asString == '1';
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }
}

/// Respuesta exacta del backend al crear un caso:
/// `{ "mensaje": "...", "codigoCaso": "#XX-XXXXX" }`.
class CreatedCaseModel {
  final String mensaje;
  final String codigoCaso;

  const CreatedCaseModel({
    required this.mensaje,
    required this.codigoCaso,
  });

  factory CreatedCaseModel.fromJson(Map<String, dynamic> json) {
    return CreatedCaseModel(
      mensaje: json['mensaje']?.toString() ?? 'Caso creado',
      codigoCaso: json['codigoCaso']?.toString() ?? '',
    );
  }
}
