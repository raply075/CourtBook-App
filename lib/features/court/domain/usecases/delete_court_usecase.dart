import '../repositories/court_repository.dart';

class DeleteCourtUseCase {
  final CourtRepository repository;

  DeleteCourtUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteCourt(id);
  }
}
