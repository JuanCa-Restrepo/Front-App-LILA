import '../../data/models/responsable_model.dart';

abstract class ResponsableRepository {
  Future<List<ResponsableModel>> fetchAll();
  Future<ResponsableModel> fetchById(String idResponsable);
}
