import '../../data/models/court_model.dart';
import '../repositories/court_repository.dart';

class AddCourtUseCase {
  final CourtRepository repository;

  AddCourtUseCase(this.repository);

  Future<void> call(CourtModel court) async {
    await repository.addCourt(court);
  }
}
