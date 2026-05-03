import '../../domain/entities/tipo_acoso.dart';
import '../../domain/repositories/tipo_acoso_repository.dart';
import '../datasources/tipo_acoso_remote_datasource.dart';

class TipoAcosoRepositoryImpl implements TipoAcosoRepository {
  final TipoAcosoRemoteDatasource _remote;

  const TipoAcosoRepositoryImpl(this._remote);

  @override
  Future<List<TipoAcoso>> fetchAll() => _remote.fetchAll();
}
