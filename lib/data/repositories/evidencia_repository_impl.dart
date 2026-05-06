import '../../domain/repositories/evidencia_repository.dart';
import '../datasources/evidencia_remote_datasource.dart';
import '../models/evidencia_model.dart';

class EvidenciaRepositoryImpl implements EvidenciaRepository {
  final EvidenciaRemoteDatasource _remote;

  const EvidenciaRepositoryImpl(this._remote);

  @override
  Future<EvidenciaModel> attachEvidence({
    required String idCaso,
    required String tipoArchivo,
    required String urlArchivo,
  }) {
    return _remote.create(
      idCaso: idCaso,
      tipoArchivo: tipoArchivo,
      urlArchivo: urlArchivo,
    );
  }

  @override
  Future<List<EvidenciaModel>> fetchByCase(String idCaso) =>
      _remote.fetchByCase(idCaso);
}
