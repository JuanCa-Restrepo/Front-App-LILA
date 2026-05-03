/// Profesional asignado al seguimiento de un caso.
class Responsable {
  final String idResponsable;
  final String nombre;
  final String? cargo;
  final String? correoEmail;
  final String? telefono;

  const Responsable({
    required this.idResponsable,
    required this.nombre,
    this.cargo,
    this.correoEmail,
    this.telefono,
  });
}
