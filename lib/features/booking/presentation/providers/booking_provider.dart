import 'package:flutter/material.dart';

import '../../data/models/booking_model.dart';
import '../../data/datasources/booking_remote_datasource.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_booking_usecase.dart';
import 'dart:io';
import '../../domain/usecases/upload_payment_proof_usecase.dart';
import '../../domain/usecases/get_booking_history_usecase.dart';

class BookingProvider extends ChangeNotifier {
  late final BookingRepositoryImpl _repository;
  late final CreateBookingUseCase _createBookingUseCase;
  late final GetBookingUseCase _getBookingUseCase;
  late final UploadPaymentProofUseCase _uploadPaymentProofUseCase;
  late final GetBookingHistoryUseCase _getBookingHistoryUseCase;

  BookingProvider() {
    _repository = BookingRepositoryImpl(BookingRemoteDataSource());

    _createBookingUseCase = CreateBookingUseCase(_repository);
    _getBookingUseCase = GetBookingUseCase(_repository);
    _uploadPaymentProofUseCase = UploadPaymentProofUseCase(_repository);
    _getBookingHistoryUseCase = GetBookingHistoryUseCase(_repository);
  }

  bool _isLoading = false;
  List<BookingModel> _bookings = [];

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;
  List<BookingModel> bookingHistory = [];

  Future<void> getBookingHistory(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      bookingHistory = await _getBookingHistoryUseCase(userId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadPaymentProof(String bookingId, File image) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _uploadPaymentProofUseCase(bookingId, image);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createBooking(BookingModel booking) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _createBookingUseCase(booking);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMyBookings(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookings = await _getBookingUseCase(userId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
