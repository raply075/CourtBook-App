import '../../data/models/dashboard_model.dart';

abstract class AdminRepository {
  Future<DashboardModel> getDashboard();
}
