import '../entities/tipo_acoso.dart';

abstract class TipoAcosoRepository {
  /// Trae el catálogo de tipos de acoso desde el backend.
  Future<List<TipoAcoso>> fetchAll();
}
