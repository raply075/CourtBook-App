import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;

import '../../../../core/services/supabase_service.dart';
import '../models/booking_model.dart';

class BookingRemoteDataSource {
  final _client = SupabaseService.client;
  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _client
        .from('bookings')
        .update({'status': status})
        .eq('id', bookingId);
  }

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

  Future<void> uploadPaymentProof(String bookingId, XFile image) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}";

    final bytes = await image.readAsBytes();

    await _client.storage.from('payment_proof').uploadBinary(fileName, bytes);

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

  Future<List<BookingModel>> getAllBookings() async {
    final response = await _client
        .from('bookings')
        .select('''
      *,
      courts(name)
      ''')
        .order('created_at', ascending: false);

    return response.map<BookingModel>((e) => BookingModel.fromJson(e)).toList();
  }
}
