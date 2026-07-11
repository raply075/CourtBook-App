import 'dart:io';

import '../repositories/booking_repository.dart';

class UploadPaymentProofUseCase {
  final BookingRepository repository;

  UploadPaymentProofUseCase(this.repository);

  Future<void> call(String bookingId, File image) {
    return repository.uploadPaymentProof(bookingId, image);
  }
}
