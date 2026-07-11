import '../../../booking/data/models/booking_model.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';
import '../models/dashboard_model.dart';
import '../models/weekly_booking_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl(this.remoteDataSource);
  @override
  Future<List<WeeklyBookingModel>> getWeeklyBooking() {
    return remoteDataSource.getWeeklyBooking();
  }

  @override
  Future<List<BookingModel>> getReportBookings() {
    return remoteDataSource.getReportBookings();
  }

  @override
  Future<DashboardModel> getDashboard() {
    return remoteDataSource.getDashboard();
  }

  @override
  Future<List<BookingModel>> getAllBookings() {
    return remoteDataSource.getAllBookings();
  }

  @override
  Future<void> confirmBooking(String bookingId) {
    return remoteDataSource.confirmBooking(bookingId);
  }

  @override
  Future<void> rejectBooking(String bookingId) {
    return remoteDataSource.rejectBooking(bookingId);
  }

  @override
  Future<BookingModel?> getBookingById(String id) {
    return remoteDataSource.getBookingById(id);
  }
}
