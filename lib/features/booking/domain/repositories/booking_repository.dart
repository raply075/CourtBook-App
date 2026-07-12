import 'package:image_picker/image_picker.dart';
import '../../data/models/booking_model.dart';

abstract class BookingRepository {
  Future<void> createBooking(BookingModel booking);

  Future<List<BookingModel>> getMyBookings(String userId);

  Future<void> uploadPaymentProof(String bookingId, XFile image);

  Future<List<BookingModel>> getBookingHistory(String userId);
}
