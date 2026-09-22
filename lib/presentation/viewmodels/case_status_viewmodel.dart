import '../../data/models/caso_model.dart';
import '../../data/models/evidencia_model.dart';
import '../../data/models/responsable_model.dart';
import '../../domain/repositories/caso_repository.dart';
import '../../domain/repositories/evidencia_repository.dart';
import '../../domain/repositories/responsable_repository.dart';
import '../demo_case_code.dart';
import 'base_view_model.dart';

/// Estado consolidado de un caso para la pantalla "Estado del Radicado".
class CaseStatusSnapshot {
  final CasoModel caso;
  final ResponsableModel? responsable;
  final List<EvidenciaModel> evidencias;
  final bool isDemo;

  const CaseStatusSnapshot({
    required this.caso,
    this.responsable,
    this.evidencias = const [],
    this.isDemo = false,
  });
}

/// ViewModel que consume:
/// - `GET /casos/codigo/:codigo` para validar/cargar el caso.
/// - `GET /responsables/:id` si el caso tiene responsable asignado.
/// - `GET /evidencias/caso/:idCaso` para listar adjuntos.
class CaseStatusViewModel extends BaseViewModel {
  final CasoRepository _casoRepository;
  final ResponsableRepository _responsableRepository;
  final EvidenciaRepository _evidenciaRepository;

  CaseStatusViewModel({
    required CasoRepository casoRepository,
    required ResponsableRepository responsableRepository,
    required EvidenciaRepository evidenciaRepository,
  })  : _casoRepository = casoRepository,
        _responsableRepository = responsableRepository,
        _evidenciaRepository = evidenciaRepository;

  CaseStatusSnapshot? _snapshot;
  CaseStatusSnapshot? get snapshot => _snapshot;

  /// Cuando el código no existe en el backend, exponemos esta bandera
  /// (separada de `errorMessage`) para que la UI muestre un texto
  /// específico tipo "Código no registrado" sin dramatismo.
  bool _codeNotFound = false;
  bool get codeNotFound => _codeNotFound;

  /// Busca un caso por su código plano. Retorna `true` si existe.
  Future<bool> lookUpByCode(String codigoCaso) async {
    _codeNotFound = false;
    _snapshot = null;
    notifyListeners();

    final trimmed = codigoCaso.trim();
    if (trimmed.toUpperCase() == demoCaseCode) {
      clearError();
      _snapshot = CaseStatusSnapshot(
        caso: CasoModel(
          idCaso: 'demo-9832',
          idUsuario: 'demo',
          idTipoAcoso: 0,
          codigoCaso: demoCaseCode,
          pasoInstitucion: false,
          estado: 'pendiente',
          fechaReporte: DateTime(2026, 5, 8, 11, 1),
          fechaActualizacion: DateTime(2026, 5, 8, 11, 1),
        ),
        isDemo: true,
      );
      notifyListeners();
      return true;
    }

    final result = await guard<CaseStatusSnapshot?>(() async {
      if (trimmed.isEmpty) return null;

      final caso = await _casoRepository.findByCodigo(trimmed);
      if (caso == null) return null;

      ResponsableModel? responsable;
      if (caso.idResponsable != null && caso.idResponsable!.isNotEmpty) {
        responsable =
            await _responsableRepository.fetchById(caso.idResponsable!);
      }

      final evidencias =
          await _evidenciaRepository.fetchByCase(caso.idCaso);

      return CaseStatusSnapshot(
        caso: caso,
        responsable: responsable,
        evidencias: evidencias,
      );
    });

    if (result == null) {
      if (errorMessage == null) {
        _codeNotFound = true;
        notifyListeners();
      }
      return false;
    }

    _snapshot = result;
    notifyListeners();
    return true;
  }

  void clear() {
    _snapshot = null;
    _codeNotFound = false;
    clearError();
    notifyListeners();
  }
}
