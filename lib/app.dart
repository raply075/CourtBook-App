import 'package:flutter/material.dart';

import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/court/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';

class CourtBookApp extends StatelessWidget {
  const CourtBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "CourtBook",

          themeMode: themeProvider.themeMode,

          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            brightness: Brightness.light,
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            brightness: Brightness.dark,
          ),

          home: const SplashPage(),

          routes: {
            "/login": (_) => const LoginPage(),
            "/register": (_) => const RegisterPage(),
            "/home": (_) => const HomePage(),
          },
        );
      },
    );
  }
}
