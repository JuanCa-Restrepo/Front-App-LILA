import '../../domain/entities/responsable.dart';
import '../../domain/repositories/responsable_repository.dart';
import '../datasources/responsable_remote_datasource.dart';

class ResponsableRepositoryImpl implements ResponsableRepository {
  final ResponsableRemoteDatasource _remote;

  const ResponsableRepositoryImpl(this._remote);

  @override
  Future<List<Responsable>> fetchAll() => _remote.fetchAll();

  @override
  Future<Responsable> fetchById(String idResponsable) =>
      _remote.fetchById(idResponsable);
}
