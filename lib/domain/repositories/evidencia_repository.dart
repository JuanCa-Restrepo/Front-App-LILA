import '../../data/models/evidencia_model.dart';

abstract class EvidenciaRepository {
  /// Registra una evidencia. La URL ya debe estar alojada (Google Drive).
  Future<EvidenciaModel> attachEvidence({
    required String idCaso,
    required String tipoArchivo,
    required String urlArchivo,
  });

  Future<List<EvidenciaModel>> fetchByCase(String idCaso);
}
