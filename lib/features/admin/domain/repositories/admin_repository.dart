import '../../../booking/data/models/booking_model.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/models/weekly_booking_model.dart';

abstract class AdminRepository {
  Future<DashboardModel> getDashboard();

  Future<List<BookingModel>> getAllBookings();

  Future<void> confirmBooking(String bookingId);

  Future<void> rejectBooking(String bookingId);
  Future<BookingModel?> getBookingById(String id);
  Future<List<WeeklyBookingModel>> getWeeklyBooking();
  Future<List<BookingModel>> getReportBookings();
}
