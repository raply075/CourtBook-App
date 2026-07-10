import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthProvider extends ChangeNotifier {
  late final AuthRepositoryImpl _repository;
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;
  late final LogoutUseCase _logoutUseCase;

  AuthProvider() {
    _repository = AuthRepositoryImpl(AuthRemoteDataSource());

    _loginUseCase = LoginUseCase(_repository);
    _registerUseCase = RegisterUseCase(_repository);
    _logoutUseCase = LogoutUseCase(_repository);
  }

  bool _isLoading = false;
  String? _role;

  String? get role => _role;

  bool get isLoading => _isLoading;

  User? get currentUser => _repository.currentUser;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _loginUseCase(email: email, password: password);

    // Ambil role user setelah login berhasil
    final user = _repository.currentUser;

    if (user != null) {
      _role = await _repository.getUserRole(user.id);
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _registerUseCase(
      email: email,
      password: password,
      fullName: fullName,
    );

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _logoutUseCase();

    _role = null;

    _isLoading = false;
    notifyListeners();
  }
}
