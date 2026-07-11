import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../booking/data/models/booking_model.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/dashboard_model.dart';

class AdminRemoteDataSource {
  final SupabaseClient _client = SupabaseService.client;

  Future<DashboardModel> getDashboard() async {
    final courts = await _client.from('courts').select();
    final bookings = await _client.from('bookings').select();
    final users = await _client.from('profiles').select();
    final reviews = await _client.from('reviews').select();

    return DashboardModel(
      totalCourts: courts.length,
      totalBookings: bookings.length,
      totalUsers: users.length,
      totalReviews: reviews.length,
    );
  }

  Future<List<BookingModel>> getAllBookings() async {
    final response = await _client
        .from('bookings')
        .select('*, courts(name)')
        .order('booking_date');

    return (response as List).map((e) => BookingModel.fromJson(e)).toList();
  }

  Future<void> confirmBooking(String bookingId) async {
    await _client
        .from('bookings')
        .update({'status': 'Confirmed'})
        .eq('id', bookingId);
  }

  Future<void> rejectBooking(String bookingId) async {
    await _client
        .from('bookings')
        .update({'status': 'Rejected'})
        .eq('id', bookingId);
  }

  Future<BookingModel?> getBookingById(String id) async {
    final response = await _client
        .from('bookings')
        .select('*, courts(name)')
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;

    return BookingModel.fromJson(response);
  }
}
