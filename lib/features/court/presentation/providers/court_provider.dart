import 'package:flutter/material.dart';
import '../../../../core/services/supabase_service.dart';
import '../../data/models/court_model.dart';
import '../../data/datasources/court_remote_datasource.dart';
import '../../data/repositories/court_repository_impl.dart';
import '../../domain/usecases/get_courts_usecase.dart';
import '../../domain/usecases/add_court_usecase.dart';
import '../../domain/usecases/update_court_usecase.dart';
import '../../domain/usecases/delete_court_usecase.dart';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class CourtProvider extends ChangeNotifier {
  late final CourtRepositoryImpl _repository;
  late final GetCourtsUseCase _getCourtsUseCase;
  late final AddCourtUseCase _addCourtUseCase;
  late final UpdateCourtUseCase _updateCourtUseCase;
  late final DeleteCourtUseCase _deleteCourtUseCase;

  CourtProvider() {
    _repository = CourtRepositoryImpl(CourtRemoteDataSource());

    _getCourtsUseCase = GetCourtsUseCase(_repository);
    _addCourtUseCase = AddCourtUseCase(_repository);
    _updateCourtUseCase = UpdateCourtUseCase(_repository);
    _deleteCourtUseCase = DeleteCourtUseCase(_repository);
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // hapus
  List<CourtModel> _courts = [];
  Future<void> deleteCourt(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _deleteCourtUseCase(id);

      _courts = await _getCourtsUseCase();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
  }

  List<CourtModel> get courts => _courts;
  Future<void> getCourts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _courts = await _getCourtsUseCase();
    } catch (e) {
      debugPrint(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  //  nambah
  Future<void> addCourt(CourtModel court) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _addCourtUseCase(court);

      // refresh list setelah berhasil insert
      _courts = await _getCourtsUseCase();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCourt(CourtModel court) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _updateCourtUseCase(court);

      _courts = await _getCourtsUseCase();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String> uploadCourtImage(Uint8List bytes, String fileName) async {
    final extension = path.extension(fileName);

    final filePath = "${const Uuid().v4()}$extension";

    await SupabaseService.client.storage
        .from('court-images')
        .uploadBinary(filePath, bytes);

    return SupabaseService.client.storage
        .from('court-images')
        .getPublicUrl(filePath);
  }
}
