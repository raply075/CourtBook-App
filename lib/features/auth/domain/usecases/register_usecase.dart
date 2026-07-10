import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthResponse> call({
    required String email,
    required String password,
    required String fullName,
  }) {
    return repository.register(
      email: email,
      password: password,
      fullName: fullName,
    );
  }
}
