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
  Future<bool> initialize() async {
    final result = await guard<String>(() async {
      final cached = await _authService.getUserId();
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }

      final deviceId = await _deviceService.getOrCreateDeviceId();
      final usuario = await _usuarioRepository.registerWithDevice(
        deviceId: deviceId,
      );
      await _authService.saveUserId(usuario.idUsuario);
      return usuario.idUsuario;
    });

    if (result != null) {
      _userId = result;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Borra el `idUsuario` cacheado. Útil para QA — fuerza un re-registro
  /// la próxima vez que se llame a `initialize()`.
  Future<void> resetSession() async {
    await _authService.clear();
    _userId = null;
    notifyListeners();
  }
}
