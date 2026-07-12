import '../../data/models/profile_model.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call(ProfileModel profile) {
    return repository.updateProfile(profile);
  }
}
