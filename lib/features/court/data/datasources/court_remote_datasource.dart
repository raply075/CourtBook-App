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

  Future<void> updateCourt(CourtModel court) async {
    await SupabaseService.client
        .from('courts')
        .update({
          'name': court.name,
          'type': court.type,
          'description': court.description,
          'image_url': court.imageUrl,
          'price': court.price,
          'is_available': court.isAvailable,
        })
        .eq('id', court.id!);
  }

  Future<void> deleteCourt(String id) async {
    await SupabaseService.client.from('courts').delete().eq('id', id);
  }
}
