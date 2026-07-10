import 'package:courtbook/features/admin/presentation/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/booking/presentation/providers/booking_provider.dart';
import 'app.dart';
import 'core/services/supabase_service.dart';

import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/court/presentation/providers/court_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

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
      ],
      child: const CourtBookApp(),
    ),
  );
}
