import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/api_constants.dart';

/// Genera y persiste un identificador único por instalación.
///
/// El backend usa este `deviceId` (UNIQUE) para distinguir un dispositivo
/// de otro. Lo cacheamos en `flutter_secure_storage` para que sobreviva
/// reinicios pero NO un factory reset / reinstalación.
class DeviceService {
  final FlutterSecureStorage _storage;

  const DeviceService(this._storage);

  /// Devuelve el `deviceId` cacheado o genera uno nuevo si no existe.
  Future<String> getOrCreateDeviceId() async {
    final cached = await _storage.read(key: StorageKeys.deviceId);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    final fresh = _generateRandomId();
    await _storage.write(key: StorageKeys.deviceId, value: fresh);
    return fresh;
  }

  /// 32 caracteres hex generados con `Random.secure`.
  String _generateRandomId() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
    return bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }
}
