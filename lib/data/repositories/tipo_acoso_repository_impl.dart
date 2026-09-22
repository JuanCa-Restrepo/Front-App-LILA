import '../../domain/repositories/tipo_acoso_repository.dart';
import '../datasources/tipo_acoso_local_datasource.dart';
import '../datasources/tipo_acoso_remote_datasource.dart';
import '../models/tipo_acoso_model.dart';

class TipoAcosoRepositoryImpl implements TipoAcosoRepository {
  final TipoAcosoRemoteDatasource _remote;
  final TipoAcosoLocalDatasource _local;

  const TipoAcosoRepositoryImpl(this._remote, this._local);

  @override
  Future<List<TipoAcosoModel>> fetchAll() async {
    try {
      final items = await _remote.fetchAll();
      try {
        await _local.saveAll(items);
      } catch (_) {
        // El catálogo remoto sigue siendo utilizable aunque falle la caché.
      }
      return items;
    } catch (_) {
      final cachedItems = await _local.fetchAll();
      if (cachedItems.isNotEmpty) return cachedItems;
      rethrow;
    }
  }
}
