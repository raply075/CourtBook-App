import 'package:flutter/material.dart';

import '../../data/models/court_model.dart';
import '../../data/datasources/court_remote_datasource.dart';
import '../../data/repositories/court_repository_impl.dart';
import '../../domain/usecases/get_courts_usecase.dart';
import '../../domain/usecases/add_court_usecase.dart';

class CourtProvider extends ChangeNotifier {
  late final CourtRepositoryImpl _repository;
  late final GetCourtsUseCase _getCourtsUseCase;
  late final AddCourtUseCase _addCourtUseCase;

  CourtProvider() {
    _repository = CourtRepositoryImpl(CourtRemoteDataSource());

    _getCourtsUseCase = GetCourtsUseCase(_repository);
    _addCourtUseCase = AddCourtUseCase(_repository);
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<CourtModel> _courts = [];

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
}
