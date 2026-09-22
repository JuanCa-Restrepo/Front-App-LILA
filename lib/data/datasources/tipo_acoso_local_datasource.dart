import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/tipo_acoso_model.dart';

class TipoAcosoLocalDatasource {
  static const _storageKey = 'tipos_acoso';

  const TipoAcosoLocalDatasource();

  Future<List<TipoAcosoModel>> fetchAll() async {
    final preferences = await SharedPreferences.getInstance();
    final rawData = preferences.getString(_storageKey);
    if (rawData == null) return const [];

    try {
      final decoded = jsonDecode(rawData);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map>()
          .map((item) => TipoAcosoModel.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList(growable: false);
    } on FormatException {
      await preferences.remove(_storageKey);
      return const [];
    } on TypeError {
      await preferences.remove(_storageKey);
      return const [];
    }
  }

  Future<void> saveAll(List<TipoAcosoModel> items) async {
    final preferences = await SharedPreferences.getInstance();
    final data = items
        .map(
          (item) => {
            'idTipoAcoso': item.idTipoAcoso,
            'descripcion': item.descripcion,
          },
        )
        .toList(growable: false);
    await preferences.setString(_storageKey, jsonEncode(data));
  }
}
