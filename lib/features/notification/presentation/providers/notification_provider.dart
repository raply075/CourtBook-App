import 'package:flutter/material.dart';

import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/usecases/get_notification_usecase.dart';

class NotificationProvider extends ChangeNotifier {
  late final GetNotificationUseCase _getNotificationUseCase;

  NotificationProvider() {
    final repository = NotificationRepositoryImpl(
      NotificationRemoteDataSource(),
    );

    _getNotificationUseCase = GetNotificationUseCase(repository);
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<NotificationModel> notifications = [];

  Future<void> getNotifications(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      notifications = await _getNotificationUseCase(userId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
