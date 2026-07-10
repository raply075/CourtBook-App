import '../../../../core/services/supabase_service.dart';
import '../models/court_model.dart';

class CourtRemoteDataSource {
  Future<List<CourtModel>> getCourts() async {
    final response = await SupabaseService.client
        .from('courts')
        .select()
        .order('created_at', ascending: true);

    return (response as List).map((e) => CourtModel.fromJson(e)).toList();
  }

  Future<void> addCourt(CourtModel court) async {
    await SupabaseService.client.from('courts').insert(court.toJson());
  }
}
