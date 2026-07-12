import 'package:courtbook/features/admin/presentation/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/booking/presentation/providers/booking_provider.dart';
import 'app.dart';
import 'core/services/supabase_service.dart';

import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/court/presentation/providers/court_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'features/notification/presentation/providers/notification_provider.dart';
import 'core/theme/theme_provider.dart';
import 'features/profile/presentation/providers/profile_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  await SupabaseService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CourtProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const CourtBookApp(),
    ),
  );
}
