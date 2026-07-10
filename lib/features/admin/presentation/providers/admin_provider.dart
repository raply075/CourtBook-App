import 'package:flutter/material.dart';

import '../../data/datasources/admin_remote_datasource.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/usecases/dashboard_usecase.dart';

class AdminProvider extends ChangeNotifier {
  late final DashboardUseCase _dashboardUseCase;

  AdminProvider() {
    final repository = AdminRepositoryImpl(AdminRemoteDataSource());

    _dashboardUseCase = DashboardUseCase(repository);
  }

  DashboardModel? _dashboard;

  DashboardModel? get dashboard => _dashboard;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> getDashboard() async {
    _isLoading = true;
    notifyListeners();

    try {
      _dashboard = await _dashboardUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
