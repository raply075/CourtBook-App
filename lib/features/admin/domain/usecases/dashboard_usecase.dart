import '../../data/models/dashboard_model.dart';
import '../repositories/admin_repository.dart';

class DashboardUseCase {
  final AdminRepository repository;

  DashboardUseCase(this.repository);

  Future<DashboardModel> call() {
    return repository.getDashboard();
  }
}
