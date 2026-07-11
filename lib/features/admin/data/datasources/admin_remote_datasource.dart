import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../booking/data/models/booking_model.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/dashboard_model.dart';
import '../models/weekly_booking_model.dart';

class AdminRemoteDataSource {
  final SupabaseClient _client = SupabaseService.client;

  Future<DashboardModel> getDashboard() async {
    final courts = await _client.from('courts').select();
    final bookings = await _client.from('bookings').select();
    final users = await _client.from('profiles').select();
    final reviews = await _client.from('reviews').select();

    int revenue = 0;

    for (final booking in bookings) {
      if (booking['status'] == 'Confirmed') {
        revenue += (booking['total_price'] as num).toInt();
      }
    }

    return DashboardModel(
      totalCourts: courts.length,
      totalBookings: bookings.length,
      totalUsers: users.length,
      totalReviews: reviews.length,
      totalRevenue: revenue,
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
    final booking = await _client
        .from('bookings')
        .select()
        .eq('id', bookingId)
        .single();

    await _client
        .from('bookings')
        .update({'status': 'Confirmed'})
        .eq('id', bookingId);

    await _client.from('notifications').insert({
      'user_id': booking['user_id'],
      'title': 'Booking Dikonfirmasi',
      'message': 'Booking Anda telah dikonfirmasi oleh admin.',
    });
  }

  Future<void> rejectBooking(String bookingId) async {
    final booking = await _client
        .from('bookings')
        .select()
        .eq('id', bookingId)
        .single();

    await _client
        .from('bookings')
        .update({'status': 'Rejected'})
        .eq('id', bookingId);

    await _client.from('notifications').insert({
      'user_id': booking['user_id'],
      'title': 'Booking Ditolak',
      'message': 'Booking Anda telah ditolak oleh admin.',
    });
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

  Future<List<WeeklyBookingModel>> getWeeklyBooking() async {
    final response = await _client.from('bookings').select('booking_date');

    final Map<String, int> data = {
      'Sen': 0,
      'Sel': 0,
      'Rab': 0,
      'Kam': 0,
      'Jum': 0,
      'Sab': 0,
      'Min': 0,
    };

    for (final item in response) {
      final date = DateTime.parse(item['booking_date']);

      switch (date.weekday) {
        case DateTime.monday:
          data['Sen'] = data['Sen']! + 1;
          break;
        case DateTime.tuesday:
          data['Sel'] = data['Sel']! + 1;
          break;
        case DateTime.wednesday:
          data['Rab'] = data['Rab']! + 1;
          break;
        case DateTime.thursday:
          data['Kam'] = data['Kam']! + 1;
          break;
        case DateTime.friday:
          data['Jum'] = data['Jum']! + 1;
          break;
        case DateTime.saturday:
          data['Sab'] = data['Sab']! + 1;
          break;
        case DateTime.sunday:
          data['Min'] = data['Min']! + 1;
          break;
      }
    }

    return data.entries
        .map((e) => WeeklyBookingModel(day: e.key, total: e.value))
        .toList();
  }

  Future<List<BookingModel>> getReportBookings() async {
    final response = await _client
        .from('bookings')
        .select('*, courts(name)')
        .order('booking_date', ascending: false);

    return (response as List).map((e) => BookingModel.fromJson(e)).toList();
  }
}
