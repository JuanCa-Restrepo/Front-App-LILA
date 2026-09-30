import 'package:flutter_test/flutter_test.dart';
import 'package:mockups/data/models/tipo_acoso_model.dart';

void main() {
  test('mapea los alias entregados por PRC_ConsultarTiposAcoso', () {
    final model = TipoAcosoModel.fromJson({
      'TipoAcosoID': 4,
      'TipoAcoso': 'Acoso psicológico',
    });

    expect(model.idTipoAcoso, 4);
    expect(model.descripcion, 'Acoso psicológico');
  });

  test('mantiene compatibilidad con el contrato canónico', () {
    final model = TipoAcosoModel.fromJson({
      'idTipoAcoso': 2,
      'descripcion': 'Acoso académico',
    });

    expect(model.idTipoAcoso, 2);
    expect(model.descripcion, 'Acoso académico');
  });

  test('rechaza una respuesta sin identificador', () {
    expect(
      () => TipoAcosoModel.fromJson({'TipoAcoso': 'Sin identificador'}),
      throwsFormatException,
    );
  });
}
