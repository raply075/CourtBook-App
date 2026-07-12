import '../../data/models/profile_model.dart';
import 'dart:typed_data';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();
  Future<String> uploadAvatar(Uint8List bytes, String fileName);
  Future<void> updateProfile(ProfileModel profile);
}
