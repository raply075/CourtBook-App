import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'court_detail_page.dart';

import '../providers/court_provider.dart';
import '../../../booking/presentation/pages/my_booking_page.dart';
import '../../../booking/presentation/pages/booking_history_page.dart';
import '../../../notification/presentation/pages/notification_page.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CourtProvider>().getCourts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final courtProvider = context.watch<CourtProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("CourtBook"),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.history),
            onSelected: (value) {
              if (value == 'booking') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyBookingPage()),
                );
              }

              if (value == 'history') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookingHistoryPage()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'booking',
                child: Text("Booking Saya"),
              ),
              const PopupMenuItem(
                value: 'history',
                child: Text("Riwayat Booking"),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              );
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, theme, child) {
              return IconButton(
                icon: Icon(theme.isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  theme.toggleTheme();
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),

      body: courtProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courtProvider.courts.length,
              itemBuilder: (context, index) {
                final court = courtProvider.courts[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourtDetailPage(court: court),
                        ),
                      );
                    },
                    leading: const Icon(Icons.sports_tennis),
                    title: Text(court.name),
                    subtitle: Text("${court.type}\nRp ${court.price}/jam"),
                    isThreeLine: true,
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
    );
  }
}
