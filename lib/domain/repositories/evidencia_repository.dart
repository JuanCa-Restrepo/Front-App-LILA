import '../entities/evidencia.dart';

abstract class EvidenciaRepository {
  /// Registra una evidencia. La URL ya debe estar alojada (Google Drive).
  Future<Evidencia> attachEvidence({
    required String idCaso,
    required String tipoArchivo,
    required String urlArchivo,
  });

  Future<List<Evidencia>> fetchByCase(String idCaso);
}
