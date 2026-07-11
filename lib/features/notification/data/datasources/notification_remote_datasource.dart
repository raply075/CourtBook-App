import '../../../../core/services/supabase_service.dart';
import '../models/notification_model.dart';

class NotificationRemoteDataSource {
  final _client = SupabaseService.client;

  Future<List<NotificationModel>> getNotifications(String userId) async {
    final response = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response
        .map<NotificationModel>((e) => NotificationModel.fromJson(e))
        .toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }
}
