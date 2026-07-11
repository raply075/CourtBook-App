import 'package:flutter/material.dart';
import '../../../booking/data/models/booking_model.dart';
import '../../domain/usecases/manage_booking_usecase.dart';
import '../../data/datasources/admin_remote_datasource.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/usecases/dashboard_usecase.dart';
import '../../data/models/weekly_booking_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';

class AdminProvider extends ChangeNotifier {
  late final DashboardUseCase _dashboardUseCase;
  late final ManageBookingUseCase _manageBookingUseCase;
  RealtimeChannel? _bookingChannel;
  void startRealtime() {
    _bookingChannel = SupabaseService.client
        .channel('booking_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'bookings',
          callback: (payload) async {
            await getDashboard();
          },
        )
        .subscribe();
  }

  void stopRealtime() {
    if (_bookingChannel != null) {
      SupabaseService.client.removeChannel(_bookingChannel!);
      _bookingChannel = null;
    }
  }

  AdminProvider() {
    final repository = AdminRepositoryImpl(AdminRemoteDataSource());

    _dashboardUseCase = DashboardUseCase(repository);
    _manageBookingUseCase = ManageBookingUseCase(repository);
  }

  List<WeeklyBookingModel> weeklyBooking = [];
  Future<void> getWeeklyBooking() async {
    weeklyBooking = await _dashboardUseCase.getWeeklyBooking();
    notifyListeners();
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
      weeklyBooking = await _dashboardUseCase.getWeeklyBooking();
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

  Future<void> confirmBookingByQr(String bookingId) async {
    await _manageBookingUseCase.confirmBooking(bookingId);
  }

  BookingModel? scannedBooking;

  Future<void> getBookingById(String id) async {
    scannedBooking = await _manageBookingUseCase.getBookingById(id);
    notifyListeners();
  }
}
