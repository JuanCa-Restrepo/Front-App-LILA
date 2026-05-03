import '../../domain/entities/tipo_acoso.dart';
import '../../domain/repositories/tipo_acoso_repository.dart';
import 'base_view_model.dart';

/// Provee el catálogo de tipos de acoso (`GET /tipos-acoso`).
///
/// Se carga una sola vez por sesión: si la lista ya está cargada,
/// `load()` no vuelve a pegarle al backend a menos que `force == true`.
class TipoAcosoViewModel extends BaseViewModel {
  final TipoAcosoRepository _repository;

  TipoAcosoViewModel(this._repository);

  List<TipoAcoso> _items = const [];
  List<TipoAcoso> get items => _items;

  bool get isLoaded => _items.isNotEmpty;

  Future<void> load({bool force = false}) async {
    if (isLoaded && !force) return;
    final result = await guard<List<TipoAcoso>>(() {
      return _repository.fetchAll();
    });
    if (result != null) {
      _items = result;
      notifyListeners();
    }
  }
}
