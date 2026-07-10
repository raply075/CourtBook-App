import '../../domain/repositories/court_repository.dart';
import '../datasources/court_remote_datasource.dart';
import '../models/court_model.dart';

class CourtRepositoryImpl implements CourtRepository {
  final CourtRemoteDataSource remoteDataSource;

  CourtRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CourtModel>> getCourts() {
    return remoteDataSource.getCourts();
  }

  @override
  Future<void> addCourt(CourtModel court) {
    return remoteDataSource.addCourt(court);
  }

  @override
  Future<void> updateCourt(CourtModel court) {
    return remoteDataSource.updateCourt(court);
  }

  @override
  Future<void> deleteCourt(String id) {
    return remoteDataSource.deleteCourt(id);
  }
}
