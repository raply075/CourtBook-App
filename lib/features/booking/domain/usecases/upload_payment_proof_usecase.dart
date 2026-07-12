import 'package:image_picker/image_picker.dart';

import '../repositories/booking_repository.dart';

class UploadPaymentProofUseCase {
  final BookingRepository repository;

  UploadPaymentProofUseCase(this.repository);

  Future<void> call(String bookingId, XFile image) {
    return repository.uploadPaymentProof(bookingId, image);
  }
}
