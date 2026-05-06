/// Constantes de configuración de la API LILA.
///
/// Cambia [baseUrl] cuando muevas el backend a otra IP o a producción.
/// El backend corre por defecto en `http://192.168.1.13:3000` y expone
/// todas sus rutas bajo el prefijo `/api`.
class ApiConstants {
  ApiConstants._();

  /// IP del PC donde corre el backend Node + puerto Express.
  static const String host = 'http://10.6.209.230:3000';

  /// Prefijo común a todas las rutas REST.
  static const String apiPrefix = '/api';

  /// URL base completa que recibe el cliente Dio.
  static const String baseUrl = '$host$apiPrefix';

  // ===== Endpoints =====
  static const String usuarios = '/usuarios';
  static const String tiposAcoso = '/tipos-acoso';
  static const String casos = '/casos';
  static const String responsables = '/responsables';
  static const String evidencias = '/evidencias';

  /// Tiempo máximo de espera por petición.
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
}

/// Claves utilizadas para almacenar datos sensibles en
/// `flutter_secure_storage`.
class StorageKeys {
  StorageKeys._();

  /// UUID del usuario actual (devuelto por el backend al primer arranque).
  static const String userId = 'lila.userId';

  /// Identificador estable del dispositivo, generado en la primera apertura.
  static const String deviceId = 'lila.deviceId';
}
