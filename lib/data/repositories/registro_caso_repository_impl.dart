import '../../domain/repositories/registro_caso_repository.dart';
import '../datasources/registro_caso_remote_datasource.dart';
import '../dtos/registro_caso_dto.dart';

class RegistroCasoRepositoryImpl implements RegistroCasoRepository {
  final RegistroCasoRemoteDatasource _remote;

  const RegistroCasoRepositoryImpl(this._remote);

  @override
  Future<void> register(RegistroCasoDto dto) => _remote.register(dto);
}
