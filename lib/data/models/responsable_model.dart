/// Profesional asignado al seguimiento de un caso.
class ResponsableModel {
  final String idResponsable;
  final String nombre;
  final String? cargo;
  final String? correoEmail;
  final String? telefono;

  const ResponsableModel({
    required this.idResponsable,
    required this.nombre,
    this.cargo,
    this.correoEmail,
    this.telefono,
  });

  factory ResponsableModel.fromJson(Map<String, dynamic> json) {
    return ResponsableModel(
      idResponsable: json['idResponsable'] as String,
      nombre: json['nombre']?.toString() ?? '',
      cargo: json['cargo'] as String?,
      correoEmail: json['correoEmail'] as String?,
      telefono: json['telefono'] as String?,
    );
  }
}
