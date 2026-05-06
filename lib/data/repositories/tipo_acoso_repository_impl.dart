import '../../domain/repositories/tipo_acoso_repository.dart';
import '../datasources/tipo_acoso_remote_datasource.dart';
import '../models/tipo_acoso_model.dart';

class TipoAcosoRepositoryImpl implements TipoAcosoRepository {
  final TipoAcosoRemoteDatasource _remote;

  const TipoAcosoRepositoryImpl(this._remote);

  @override
  Future<List<TipoAcosoModel>> fetchAll() => _remote.fetchAll();
}
