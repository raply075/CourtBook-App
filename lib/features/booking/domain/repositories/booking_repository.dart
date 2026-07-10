import '../../data/models/booking_model.dart';

abstract class BookingRepository {
  Future<void> createBooking(BookingModel booking);

  Future<List<BookingModel>> getMyBookings(String userId);
}
