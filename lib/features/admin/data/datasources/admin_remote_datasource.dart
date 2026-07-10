import 'package:supabase_flutter/supabase_flutter.dart';

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
}
