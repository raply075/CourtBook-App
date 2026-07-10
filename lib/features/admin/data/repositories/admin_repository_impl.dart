import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';
import '../models/dashboard_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl(this.remoteDataSource);

  @override
  Future<DashboardModel> getDashboard() {
    return remoteDataSource.getDashboard();
  }
}
