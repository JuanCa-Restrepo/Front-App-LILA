import '../../core/services/google_drive_uploader.dart';
import '../../domain/entities/evidencia.dart';
import '../../domain/repositories/evidencia_repository.dart';
import 'base_view_model.dart';

/// Maneja la subida de evidencias para un caso ya creado.
///
/// Útil desde la pantalla "Estado del Radicado" cuando el usuario quiere
/// adjuntar un documento adicional (por ejemplo, el consentimiento PDF).
class EvidenciaViewModel extends BaseViewModel {
  final EvidenciaRepository _repository;
  final GoogleDriveUploader _driveUploader;

  EvidenciaViewModel({
    required EvidenciaRepository repository,
    required GoogleDriveUploader driveUploader,
  })  : _repository = repository,
        _driveUploader = driveUploader;

  Evidencia? _lastUploaded;
  Evidencia? get lastUploaded => _lastUploaded;

  /// Sube `localPath` a Drive y registra la evidencia contra `idCaso`.
  Future<bool> uploadAndAttach({
    required String idCaso,
    required String localPath,
    required String tipoArchivo,
    String? fileName,
  }) async {
    final result = await guard<Evidencia>(() async {
      final url = await _driveUploader.upload(
        localPath: localPath,
        tipoArchivo: tipoArchivo,
        fileName: fileName,
      );
      return _repository.attachEvidence(
        idCaso: idCaso,
        tipoArchivo: tipoArchivo,
        urlArchivo: url,
      );
    });

    if (result == null) return false;
    _lastUploaded = result;
    notifyListeners();
    return true;
  }
}
