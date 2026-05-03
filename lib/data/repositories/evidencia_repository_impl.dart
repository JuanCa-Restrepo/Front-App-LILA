import '../../domain/entities/evidencia.dart';
import '../../domain/repositories/evidencia_repository.dart';
import '../datasources/evidencia_remote_datasource.dart';

class EvidenciaRepositoryImpl implements EvidenciaRepository {
  final EvidenciaRemoteDatasource _remote;

  const EvidenciaRepositoryImpl(this._remote);

  @override
  Future<Evidencia> attachEvidence({
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
  Future<List<Evidencia>> fetchByCase(String idCaso) =>
      _remote.fetchByCase(idCaso);
}
