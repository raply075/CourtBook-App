import '../../data/models/booking_model.dart';
import '../repositories/booking_repository.dart';

class GetBookingHistoryUseCase {
  final BookingRepository repository;

  GetBookingHistoryUseCase(this.repository);

  Future<List<BookingModel>> call(String userId) {
    return repository.getBookingHistory(userId);
  }
}
