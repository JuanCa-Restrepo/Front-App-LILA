import '../../core/errors/app_exceptions.dart';
import '../../domain/entities/caso.dart';
import '../../domain/repositories/caso_repository.dart';
import '../datasources/caso_remote_datasource.dart';

class CasoRepositoryImpl implements CasoRepository {
  final CasoRemoteDatasource _remote;

  const CasoRepositoryImpl(this._remote);

  @override
  Future<CreatedCaseInfo> createCase({
    required String idUsuario,
    required int idTipoAcoso,
    String? idResponsable,
    required bool pasoInstitucion,
    String? descripcion,
  }) async {
    final result = await _remote.create(
      idUsuario: idUsuario,
      idTipoAcoso: idTipoAcoso,
      idResponsable: idResponsable,
      pasoInstitucion: pasoInstitucion,
      descripcion: descripcion,
    );
    return CreatedCaseInfo(
      codigoCaso: result.codigoCaso,
      mensaje: result.mensaje,
    );
  }

  @override
  Future<Caso?> findByCodigo(String codigoCaso) async {
    try {
      return await _remote.fetchByCodigo(codigoCaso);
    } on NotFoundException {
      // El backend devuelve 404 cuando el código no existe; lo
      // traducimos a `null` para que la UI pueda mostrar
      // "Código no registrado" sin tratarlo como un fallo de red.
      return null;
    }
  }

  @override
  Future<Caso?> findById(String idCaso) async {
    try {
      return await _remote.fetchById(idCaso);
    } on NotFoundException {
      return null;
    }
  }

  @override
  Future<List<Caso>> fetchAll() => _remote.fetchAll();
}
