import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/api_constants.dart';

/// Persiste el `idUsuario` actual en almacenamiento seguro.
///
/// La app no maneja JWT — la "sesión" es simplemente el UUID del usuario
/// que el backend devolvió al primer arranque. Si `getUserId()` retorna
/// `null` significa que aún no se ha registrado el dispositivo.
class AuthService {
  final FlutterSecureStorage _storage;

  const AuthService(this._storage);

  Future<String?> getUserId() {
    return _storage.read(key: StorageKeys.userId);
  }

  Future<void> saveUserId(String idUsuario) {
    return _storage.write(key: StorageKeys.userId, value: idUsuario);
  }

  Future<void> clear() {
    return _storage.delete(key: StorageKeys.userId);
  }
}
