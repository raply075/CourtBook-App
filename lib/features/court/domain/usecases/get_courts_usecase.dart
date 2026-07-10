import '../../data/models/court_model.dart';
import '../repositories/court_repository.dart';

class GetCourtsUseCase {
  final CourtRepository repository;

  GetCourtsUseCase(this.repository);

  Future<List<CourtModel>> call() {
    return repository.getCourts();
  }
}
