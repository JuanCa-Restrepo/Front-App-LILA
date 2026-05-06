import '../../data/models/tipo_acoso_model.dart';

abstract class TipoAcosoRepository {
  /// Trae el catálogo de tipos de acoso desde el backend.
  Future<List<TipoAcosoModel>> fetchAll();
}
