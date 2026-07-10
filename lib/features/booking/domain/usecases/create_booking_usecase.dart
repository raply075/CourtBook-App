import '../../data/models/booking_model.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<void> call(BookingModel booking) {
    return repository.createBooking(booking);
  }
}
