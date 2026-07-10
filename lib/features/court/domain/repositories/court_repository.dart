import '../../data/models/court_model.dart';

abstract class CourtRepository {
  Future<List<CourtModel>> getCourts();

  Future<void> addCourt(CourtModel court);

  Future<void> updateCourt(CourtModel court);

  Future<void> deleteCourt(String id);
}
