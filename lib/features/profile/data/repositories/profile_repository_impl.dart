import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';
import 'dart:typed_data';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProfileModel> getProfile() {
    return remoteDataSource.getProfile();
  }

  @override
  Future<String> uploadAvatar(Uint8List bytes, String fileName) {
    return remoteDataSource.uploadAvatar(bytes, fileName);
  }

  @override
  Future<void> updateProfile(ProfileModel profile) {
    return remoteDataSource.updateProfile(profile);
  }
}
