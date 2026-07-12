import '../../data/models/profile_model.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<ProfileModel> call() {
    return repository.getProfile();
  }
}
