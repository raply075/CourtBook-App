import '../../data/models/booking_model.dart';
import '../repositories/booking_repository.dart';

class GetBookingUseCase {
  final BookingRepository repository;

  GetBookingUseCase(this.repository);

  Future<List<BookingModel>> call(String userId) {
    return repository.getMyBookings(userId);
  }
}
