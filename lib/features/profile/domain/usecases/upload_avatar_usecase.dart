import 'dart:typed_data';

import '../repositories/profile_repository.dart';

class UploadAvatarUseCase {
  final ProfileRepository repository;

  UploadAvatarUseCase(this.repository);

  Future<String> call(Uint8List bytes, String fileName) {
    return repository.uploadAvatar(bytes, fileName);
  }
}
