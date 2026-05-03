import '../../domain/entities/responsable.dart';

class ResponsableModel extends Responsable {
  const ResponsableModel({
    required super.idResponsable,
    required super.nombre,
    super.cargo,
    super.correoEmail,
    super.telefono,
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
