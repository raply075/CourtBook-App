import '../../data/models/booking_model.dart';
import 'dart:io';

abstract class BookingRepository {
  Future<void> createBooking(BookingModel booking);

  Future<List<BookingModel>> getMyBookings(String userId);

  Future<void> uploadPaymentProof(String bookingId, File image);
  Future<List<BookingModel>> getBookingHistory(String userId);
}
