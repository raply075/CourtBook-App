import '../../../../core/services/supabase_service.dart';
import '../models/profile_model.dart';
import 'dart:typed_data';

class ProfileRemoteDataSource {
  final _client = SupabaseService.client;

  Future<ProfileModel> getProfile() async {
    final user = _client.auth.currentUser!;

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return ProfileModel.fromJson(response);
  }

  Future<void> updateProfile(ProfileModel profile) async {
    try {
      final res = await _client
          .from('profiles')
          .update(profile.toJson())
          .eq('id', profile.id)
          .select();

      print("UPDATE BERHASIL");
      print(res);
    } catch (e) {
      print("UPDATE ERROR");
      print(e);
      rethrow;
    }
  }

  Future<String> uploadAvatar(Uint8List bytes, String fileName) async {
    await _client.storage.from('avatars').uploadBinary(fileName, bytes);

    return _client.storage.from('avatars').getPublicUrl(fileName);
  }
}
