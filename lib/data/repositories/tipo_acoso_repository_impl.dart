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
    // Mostrar primero el último catálogo disponible evita bloquear el paso
    // mientras una IP local inaccesible agota el timeout de conexión.
    try {
      final cachedItems = await _local.fetchAll();
      if (cachedItems.isNotEmpty) return cachedItems;
    } catch (_) {
      // La lectura de caché no debe impedir la carga del catálogo.
    }

    try {
      final items = await _remote.fetchAll().timeout(const Duration(seconds: 2));
      try {
        await _local.saveAll(items);
      } catch (_) {
        // El catálogo remoto sigue siendo utilizable aunque falle la caché.
      }
      return items;
    } catch (_) {
      // Modo visual/demo sin backend: catálogo local fijo.
      return const [
        TipoAcosoModel(idTipoAcoso: 1, descripcion: 'Acoso verbal'),
        TipoAcosoModel(idTipoAcoso: 2, descripcion: 'Acoso físico'),
        TipoAcosoModel(idTipoAcoso: 3, descripcion: 'Acoso sexual'),
        TipoAcosoModel(idTipoAcoso: 4, descripcion: 'Acoso digital'),
      ];
    }
  }
}
