import '../../../booking/data/models/booking_model.dart';
import '../repositories/admin_repository.dart';

class ManageBookingUseCase {
  final AdminRepository repository;

  ManageBookingUseCase(this.repository);

  Future<List<BookingModel>> getBookings() {
    return repository.getAllBookings();
  }

  Future<void> confirmBooking(String id) {
    return repository.confirmBooking(id);
  }

  Future<void> rejectBooking(String id) {
    return repository.rejectBooking(id);
  }
}
