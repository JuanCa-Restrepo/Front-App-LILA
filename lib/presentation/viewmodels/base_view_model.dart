import 'package:flutter/foundation.dart';

import '../../core/errors/app_exceptions.dart';

/// Base común a todos los ViewModel de la app.
///
/// Centraliza el estado de carga, el mensaje de error y un helper
/// `guard` que envuelve cualquier operación asíncrona aplicando las
/// reglas estándar:
/// - antes: `isLoading = true`, limpia el error previo.
/// - éxito: devuelve el resultado; `isLoading = false`.
/// - `AppException`: expone `errorMessage` y devuelve `null`.
/// - cualquier otro error: lo convierte en mensaje genérico.
///
/// Los ViewModel concretos NUNCA deben importar widgets de Flutter,
/// solo `ChangeNotifier`. Por eso usamos `package:flutter/foundation.dart`.
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _disposed = false;

  void clearError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
    _safeNotify();
  }

  /// Ejecuta `action`, gestionando `isLoading` y `errorMessage`.
  /// Devuelve `null` si la operación falla.
  @protected
  Future<T?> guard<T>(Future<T> Function() action) async {
    _errorMessage = null;
    _isLoading = true;
    _safeNotify();
    try {
      final result = await action();
      return result;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (e) {
      _errorMessage = 'Error inesperado: $e';
      return null;
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  /// Permite a subclases setear el mensaje de error sin lanzar excepción.
  @protected
  void setError(String message) {
    _errorMessage = message;
    _safeNotify();
  }

  void _safeNotify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
