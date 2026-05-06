import '../../domain/repositories/responsable_repository.dart';
import '../datasources/responsable_remote_datasource.dart';
import '../models/responsable_model.dart';

class ResponsableRepositoryImpl implements ResponsableRepository {
  final ResponsableRemoteDatasource _remote;

  const ResponsableRepositoryImpl(this._remote);

  @override
  Future<List<ResponsableModel>> fetchAll() => _remote.fetchAll();

  @override
  Future<ResponsableModel> fetchById(String idResponsable) =>
      _remote.fetchById(idResponsable);
}
