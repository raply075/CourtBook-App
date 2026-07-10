import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';

class AuthRemoteDataSource {
  final SupabaseClient _client = SupabaseService.client;

  User? get currentUser => _client.auth.currentUser;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  Future<String?> getUserRole(String userId) async {
    final response = await _client
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .single();

    return response['role'] as String?;
  }
}
