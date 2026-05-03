import '../../domain/entities/usuario.dart';

/// Modelo de transporte para `Usuario`.
///
/// Mantiene exactamente los nombres de campos que devuelve el backend
/// (`idUsuario`, `correoEmail`, etc.) para evitar dobles mapeos.
class UsuarioModel extends Usuario {
  const UsuarioModel({
    required super.idUsuario,
    super.cedula,
    super.telefono,
    super.fechaRegistro,
    super.estado,
    super.sexoBiologico,
    super.orientacionGenero,
    super.correoEmail,
    super.tipoUsuario,
    super.deviceId,
  });

  /// Construye el modelo a partir de la respuesta JSON del backend.
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      idUsuario: json['idUsuario'] as String,
      cedula: json['cedula'] as String?,
      telefono: json['telefono'] as String?,
      fechaRegistro: _parseDate(json['fechaRegistro']),
      estado: _parseBool(json['estado']) ?? true,
      sexoBiologico: json['sexoBiologico'] as String?,
      orientacionGenero: json['orientacionGenero'] as String?,
      correoEmail: json['correoEmail'] as String?,
      tipoUsuario: json['tipoUsuario'] as String?,
      deviceId: json['deviceId'] as String?,
    );
  }

  /// Cuerpo para `POST /usuarios`. Solo enviamos los campos no nulos
  /// que el backend espera; el `idUsuario` lo genera el servidor.
  Map<String, dynamic> toCreateJson() {
    return {
      if (cedula != null) 'cedula': cedula,
      if (telefono != null) 'telefono': telefono,
      if (sexoBiologico != null) 'sexoBiologico': sexoBiologico,
      if (orientacionGenero != null) 'orientacionGenero': orientacionGenero,
      if (correoEmail != null) 'correoEmail': correoEmail,
      if (tipoUsuario != null) 'tipoUsuario': tipoUsuario,
      if (deviceId != null) 'deviceId': deviceId,
    };
  }

  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }

  static bool? _parseBool(dynamic raw) {
    if (raw == null) return null;
    if (raw is bool) return raw;
    if (raw is num) return raw != 0;
    final asString = raw.toString().toLowerCase();
    if (asString == 'true' || asString == '1') return true;
    if (asString == 'false' || asString == '0') return false;
    return null;
  }
}
