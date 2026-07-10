import '../../data/models/court_model.dart';
import '../repositories/court_repository.dart';

class UpdateCourtUseCase {
  final CourtRepository repository;

  UpdateCourtUseCase(this.repository);

  Future<void> call(CourtModel court) {
    return repository.updateCourt(court);
  }
}
