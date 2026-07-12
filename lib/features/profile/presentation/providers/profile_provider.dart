import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_avatar_usecase.dart';

class ProfileProvider extends ChangeNotifier {
  late final ProfileRepositoryImpl _repository;
  late final GetProfileUseCase _getProfileUseCase;
  late final UpdateProfileUseCase _updateProfileUseCase;
  late final UploadAvatarUseCase _uploadAvatarUseCase;

  ProfileProvider() {
    _repository = ProfileRepositoryImpl(ProfileRemoteDataSource());

    _getProfileUseCase = GetProfileUseCase(_repository);
    _updateProfileUseCase = UpdateProfileUseCase(_repository);
    _uploadAvatarUseCase = UploadAvatarUseCase(_repository);
  }

  bool _isLoading = false;

  ProfileModel? _profile;

  bool get isLoading => _isLoading;

  ProfileModel? get profile => _profile;

  Future<void> getProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await _getProfileUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(ProfileModel profile) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _updateProfileUseCase(profile);
      _profile = profile;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> uploadAvatar(Uint8List bytes, String fileName) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = await _uploadAvatarUseCase(bytes, fileName);

      if (_profile != null) {
        _profile = _profile!.copyWith(avatarUrl: url);

        await _updateProfileUseCase(_profile!);
      }

      return url;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
