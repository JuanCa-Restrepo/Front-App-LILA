import '../../core/services/auth_service.dart';
import '../../core/services/google_drive_uploader.dart';
import '../../domain/repositories/caso_repository.dart';
import '../../domain/repositories/evidencia_repository.dart';
import 'base_view_model.dart';

/// Categorías de "afectado" del Step 1 (mapean al campo `tipoUsuario`
/// que el backend almacena en la tabla `usuario`).
enum AffectedPersonType {
  ninioNinia,
  adolescente,
  adulto;

  String get backendValue {
    switch (this) {
      case AffectedPersonType.ninioNinia:
        return 'nino_nina';
      case AffectedPersonType.adolescente:
        return 'adolescente';
      case AffectedPersonType.adulto:
        return 'adulto';
    }
  }
}

/// Archivo seleccionado por el usuario en el Step 5, listo para subir.
class EvidenceDraft {
  final String localPath;
  final String tipoArchivo; // 'image' | 'audio' | 'video' | 'pdf'
  final String? fileName;

  const EvidenceDraft({
    required this.localPath,
    required this.tipoArchivo,
    this.fileName,
  });
}

/// ViewModel que acumula el estado de los 5 pasos del reporte y
/// dispara la creación del caso en el backend (+ subida de evidencias).
///
/// Se registra como un `ChangeNotifierProvider` que vive durante todo
/// el flujo y se resetea cuando el usuario termina (`reset()`).
class ReportCaseViewModel extends BaseViewModel {
  final CasoRepository _casoRepository;
  final EvidenciaRepository _evidenciaRepository;
  final GoogleDriveUploader _driveUploader;
  final AuthService _authService;

  ReportCaseViewModel({
    required CasoRepository casoRepository,
    required EvidenciaRepository evidenciaRepository,
    required GoogleDriveUploader driveUploader,
    required AuthService authService,
  })  : _casoRepository = casoRepository,
        _evidenciaRepository = evidenciaRepository,
        _driveUploader = driveUploader,
        _authService = authService;

  // ===== Step 1 — datos del afectado =====
  AffectedPersonType _personType = AffectedPersonType.adolescente;
  String? _sexoBiologico;
  String? _orientacionGenero;

  AffectedPersonType get personType => _personType;
  String? get sexoBiologico => _sexoBiologico;
  String? get orientacionGenero => _orientacionGenero;

  void setPersonType(AffectedPersonType value) {
    _personType = value;
    notifyListeners();
  }

  void setSexoBiologico(String? value) {
    _sexoBiologico = value;
    notifyListeners();
  }

  void setOrientacionGenero(String? value) {
    _orientacionGenero = value;
    notifyListeners();
  }

  // ===== Step 2 — tipo de acoso =====
  int? _idTipoAcoso;
  int? get idTipoAcoso => _idTipoAcoso;

  void setIdTipoAcoso(int? value) {
    _idTipoAcoso = value;
    notifyListeners();
  }

  // ===== Step 3 — pasó dentro de la institución =====
  bool? _pasoInstitucion;
  bool? get pasoInstitucion => _pasoInstitucion;

  void setPasoInstitucion(bool value) {
    _pasoInstitucion = value;
    notifyListeners();
  }

  // ===== Step 4 — descripción =====
  String _descripcion = '';
  String get descripcion => _descripcion;

  void setDescripcion(String value) {
    _descripcion = value;
    notifyListeners();
  }

  // ===== Step 5 — evidencias en cola =====
  final List<EvidenceDraft> _pendingEvidences = [];
  List<EvidenceDraft> get pendingEvidences =>
      List.unmodifiable(_pendingEvidences);

  void addEvidence(EvidenceDraft draft) {
    _pendingEvidences.add(draft);
    notifyListeners();
  }

  void removeEvidenceAt(int index) {
    if (index < 0 || index >= _pendingEvidences.length) return;
    _pendingEvidences.removeAt(index);
    notifyListeners();
  }

  // ===== Resultado del envío =====
  String? _generatedCodigoCaso;
  String? get generatedCodigoCaso => _generatedCodigoCaso;

  // ===== Validación previa al envío =====
  String? validateBeforeSubmit() {
    if (_idTipoAcoso == null) {
      return 'Debes seleccionar el tipo de acoso (Paso 2).';
    }
    if (_pasoInstitucion == null) {
      return 'Debes responder si pasó dentro de la institución (Paso 3).';
    }
    if (_descripcion.trim().length < 10) {
      return 'La descripción del caso debe tener al menos 10 caracteres.';
    }
    return null;
  }

  /// Crea el caso, sube evidencias a Drive y registra cada URL.
  /// Retorna `true` si el caso se creó correctamente.
  Future<bool> submit() async {
    final validation = validateBeforeSubmit();
    if (validation != null) {
      setError(validation);
      return false;
    }

    final userId = await _authService.getUserId();
    if (userId == null) {
      setError(
        'No se ha inicializado el usuario. Reinicia la app para reintentar.',
      );
      return false;
    }

    final result = await guard<String>(() async {
      final created = await _casoRepository.createCase(
        idUsuario: userId,
        idTipoAcoso: _idTipoAcoso!,
        pasoInstitucion: _pasoInstitucion!,
        descripcion: _descripcion.trim(),
      );

      // Para enlazar evidencias necesitamos el `idCaso`. Lo recuperamos
      // por el código que acabamos de obtener.
      if (_pendingEvidences.isNotEmpty) {
        final caso = await _casoRepository.findByCodigo(created.codigoCaso);
        final idCaso = caso?.idCaso;
        if (idCaso != null) {
          for (final draft in _pendingEvidences) {
            final url = await _driveUploader.upload(
              localPath: draft.localPath,
              tipoArchivo: draft.tipoArchivo,
              fileName: draft.fileName,
            );
            await _evidenciaRepository.attachEvidence(
              idCaso: idCaso,
              tipoArchivo: draft.tipoArchivo,
              urlArchivo: url,
            );
          }
        }
      }

      return created.codigoCaso;
    });

    if (result == null) return false;
    _generatedCodigoCaso = result;
    notifyListeners();
    return true;
  }

  /// Limpia todo el estado para iniciar un nuevo reporte.
  void reset() {
    _personType = AffectedPersonType.adolescente;
    _sexoBiologico = null;
    _orientacionGenero = null;
    _idTipoAcoso = null;
    _pasoInstitucion = null;
    _descripcion = '';
    _pendingEvidences.clear();
    _generatedCodigoCaso = null;
    clearError();
    notifyListeners();
  }
}
