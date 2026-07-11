import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/notification_provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final auth = context.read<AuthProvider>();

      if (auth.currentUser != null) {
        context.read<NotificationProvider>().getNotifications(
          auth.currentUser!.id,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.notifications.isEmpty
          ? const Center(child: Text("Belum ada notifikasi"))
          : ListView.builder(
              itemCount: provider.notifications.length,
              itemBuilder: (context, index) {
                final notification = provider.notifications[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        notification.isRead
                            ? Icons.notifications
                            : Icons.notifications_active,
                      ),
                    ),
                    title: Text(notification.title),
                    subtitle: Text(notification.message),
                    trailing: notification.isRead
                        ? null
                        : const Icon(
                            Icons.fiber_manual_record,
                            color: Colors.red,
                            size: 12,
                          ),
                  ),
                );
              },
            ),
    );
  }
}
