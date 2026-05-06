import '../../core/errors/app_exceptions.dart';
import '../../domain/repositories/caso_repository.dart';
import '../datasources/caso_remote_datasource.dart';
import '../models/caso_model.dart';

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
  Future<CasoModel?> findByCodigo(String codigoCaso) async {
    try {
      return await _remote.fetchByCodigo(codigoCaso);
    } on NotFoundException {
      return null;
    }
  }

  @override
  Future<CasoModel?> findById(String idCaso) async {
    try {
      return await _remote.fetchById(idCaso);
    } on NotFoundException {
      return null;
    }
  }

  @override
  Future<List<CasoModel>> fetchAll() => _remote.fetchAll();
}
