import 'dart:io';

import 'package:path/path.dart' as path;

import '../../../../core/services/supabase_service.dart';
import '../models/booking_model.dart';

class BookingRemoteDataSource {
  final _client = SupabaseService.client;

  Future<void> createBooking(BookingModel booking) async {
    await _client.from('bookings').insert(booking.toJson());
  }

  Future<List<BookingModel>> getMyBookings(String userId) async {
    final response = await _client
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

    print("=========== RAW RESPONSE ===========");
    print(response);

    final bookings = response
        .map<BookingModel>((e) => BookingModel.fromJson(e))
        .toList();

    print("=========== PARSED ===========");
    for (final b in bookings) {
      print("${b.id} -> ${b.status}");
    }

    return bookings;
  }

  Future<void> uploadPaymentProof(String bookingId, File image) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}";

    await _client.storage.from('payment_proof').upload(fileName, image);

    final imageUrl = _client.storage
        .from('payment_proof')
        .getPublicUrl(fileName);

    await _client
        .from('bookings')
        .update({'payment_proof': imageUrl})
        .eq('id', bookingId);
  }

  Future<List<BookingModel>> getBookingHistory(String userId) async {
    final response = await _client
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
        .inFilter('status', ['Completed', 'Rejected', 'Cancelled'])
        .order('created_at', ascending: false);

    return response.map<BookingModel>((e) => BookingModel.fromJson(e)).toList();
  }
}
