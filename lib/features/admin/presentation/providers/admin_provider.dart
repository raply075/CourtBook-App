import 'package:flutter/material.dart';
import '../../../booking/data/models/booking_model.dart';
import '../../domain/usecases/manage_booking_usecase.dart';
import '../../data/datasources/admin_remote_datasource.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/usecases/dashboard_usecase.dart';

class AdminProvider extends ChangeNotifier {
  late final DashboardUseCase _dashboardUseCase;
  late final ManageBookingUseCase _manageBookingUseCase;

  AdminProvider() {
    final repository = AdminRepositoryImpl(AdminRemoteDataSource());

    _dashboardUseCase = DashboardUseCase(repository);
    _manageBookingUseCase = ManageBookingUseCase(repository);
  }

  DashboardModel? _dashboard;

  DashboardModel? get dashboard => _dashboard;

  List<BookingModel> _bookings = [];

  List<BookingModel> get bookings => _bookings;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> getDashboard() async {
    _isLoading = true;
    notifyListeners();

    try {
      _dashboard = await _dashboardUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookings = await _manageBookingUseCase.getBookings();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> confirmBooking(String id) async {
    await _manageBookingUseCase.confirmBooking(id);
    await getAllBookings();
  }

  Future<void> rejectBooking(String id) async {
    await _manageBookingUseCase.rejectBooking(id);
    await getAllBookings();
  }
}
