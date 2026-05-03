import 'package:flutter/material.dart';

import 'app/app.dart';

/// Punto de entrada de la app LILA.
///
/// `WidgetsFlutterBinding.ensureInitialized()` se necesita porque toda
/// la inyección de dependencias ocurre dentro de `App` (que a su vez
/// crea `FlutterSecureStorage` y `Dio` antes del primer frame).
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}