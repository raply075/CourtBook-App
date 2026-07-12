import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> uploadPaymentProof(String bookingId, XFile image) {
    return remoteDataSource.uploadPaymentProof(bookingId, image);
  }

  @override
  Future<void> createBooking(BookingModel booking) {
    return remoteDataSource.createBooking(booking);
  }

  @override
  Future<List<BookingModel>> getMyBookings(String userId) {
    return remoteDataSource.getMyBookings(userId);
  }

  @override
  Future<List<BookingModel>> getBookingHistory(String userId) {
    return remoteDataSource.getBookingHistory(userId);
  }
}
