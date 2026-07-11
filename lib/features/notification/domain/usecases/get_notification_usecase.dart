import '../../data/models/notification_model.dart';
import '../repositories/notification_repository.dart';

class GetNotificationUseCase {
  final NotificationRepository repository;

  GetNotificationUseCase(this.repository);

  Future<List<NotificationModel>> call(String userId) {
    return repository.getNotifications(userId);
  }
}
