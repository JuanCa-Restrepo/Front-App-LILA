import '../../core/services/auth_service.dart';
import '../../core/services/device_service.dart';
import '../../domain/repositories/usuario_repository.dart';
import 'base_view_model.dart';

/// Coordina el "registro silencioso" del dispositivo.
///
/// Flujo:
/// 1. Lee el `idUsuario` cacheado en `flutter_secure_storage`.
/// 2. Si existe → la app está lista.
/// 3. Si no → genera/lee el `deviceId`, llama a `POST /usuarios` y
///    cachea el `idUsuario` que retorne el backend.
class AuthViewModel extends BaseViewModel {
  final AuthService _authService;
  final DeviceService _deviceService;
  final UsuarioRepository _usuarioRepository;

  AuthViewModel({
    required AuthService authService,
    required DeviceService deviceService,
    required UsuarioRepository usuarioRepository,
  })  : _authService = authService,
        _deviceService = deviceService,
        _usuarioRepository = usuarioRepository;

  String? _userId;
  String? get userId => _userId;

  bool get isReady => _userId != null;

  /// Ejecuta el flujo de inicialización. Llamar al arrancar la app.
  /// Modo visual/demo: si no hay backend, genera un id local y continúa.
  Future<bool> initialize() async {
    try {
      final cached = await _authService.getUserId();
      if (cached != null && cached.isNotEmpty) {
        _userId = cached;
        notifyListeners();
        return true;
      }

      try {
        final deviceId = await _deviceService.getOrCreateDeviceId();
        final usuario = await _usuarioRepository.registerWithDevice(
          deviceId: deviceId,
        );
        await _authService.saveUserId(usuario.idUsuario);
        _userId = usuario.idUsuario;
        notifyListeners();
        return true;
      } catch (_) {
        // Sin backend: sesión demo local para navegar las vistas.
        final demoId =
            'demo-${DateTime.now().millisecondsSinceEpoch}';
        try {
          await _authService.saveUserId(demoId);
        } catch (_) {
          // secure_storage puede fallar en algunas plataformas; igual seguimos.
        }
        _userId = demoId;
        clearError();
        notifyListeners();
        return true;
      }
    } catch (_) {
      return false;
    }
  }

  /// Borra el `idUsuario` cacheado. Útil para QA — fuerza un re-registro
  /// la próxima vez que se llame a `initialize()`.
  Future<void> resetSession() async {
    await _authService.clear();
    _userId = null;
    notifyListeners();
  }
}
