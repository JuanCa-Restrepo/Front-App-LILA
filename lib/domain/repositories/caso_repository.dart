import '../entities/caso.dart';

/// Resultado de la creación de un caso: el código en texto plano que el
/// usuario debe guardar para poder consultar el estado.
class CreatedCaseInfo {
  final String codigoCaso;
  final String mensaje;

  const CreatedCaseInfo({
    required this.codigoCaso,
    required this.mensaje,
  });
}

abstract class CasoRepository {
  /// Crea un nuevo caso. Devuelve el código plano generado.
  Future<CreatedCaseInfo> createCase({
    required String idUsuario,
    required int idTipoAcoso,
    String? idResponsable,
    required bool pasoInstitucion,
    String? descripcion,
  });

  /// Recupera el caso por su código plano (`#XX-XXXXX`).
  /// Devuelve `null` si no existe.
  Future<Caso?> findByCodigo(String codigoCaso);

  Future<Caso?> findById(String idCaso);

  Future<List<Caso>> fetchAll();
}
