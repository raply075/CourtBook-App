import '../../../../core/services/supabase_service.dart';
import '../models/booking_model.dart';

class BookingRemoteDataSource {
  Future<void> createBooking(BookingModel booking) async {
    await SupabaseService.client.from('bookings').insert(booking.toJson());
  }

  Future<List<BookingModel>> getMyBookings(String userId) async {
    final response = await SupabaseService.client
        .from('bookings')
        .select('''
*,
courts(
id,
name,
type,
price
)
''')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response
        .map<BookingModel>((json) => BookingModel.fromJson(json))
        .toList();
  }
}
