import '../../data/models/court_model.dart';

abstract class CourtRepository {
  Future<List<CourtModel>> getCourts();
}
