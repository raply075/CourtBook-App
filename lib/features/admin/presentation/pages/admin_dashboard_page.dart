import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../court/presentation/pages/home_page.dart';
import 'manage_booking_page.dart';

import 'manage_court_page.dart';
import 'scan_qr_page.dart';
import 'scan_result_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final auth = context.read<AuthProvider>();

      if (auth.role != 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    });
  }

  Future<void> _logout() async {
    final auth = context.read<AuthProvider>();

    await auth.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Widget menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),
        leading: CircleAvatar(radius: 26, child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Halo, Admin 👋",
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 6),

          Text(
            "Login sebagai : ${auth.role}",
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 30),

          menuCard(
            icon: Icons.sports_tennis,
            title: "Kelola Lapangan",
            subtitle: "Tambah, edit dan hapus lapangan",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageCourtPage()),
              );
            },
          ),
          menuCard(
            icon: Icons.book_online,
            title: "Kelola Booking",
            subtitle: "Konfirmasi atau tolak booking pengguna",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageBookingPage()),
              );
            },
          ),

          menuCard(
            title: "Scan QR",
            subtitle: "Scan QR Booking pengguna",
            icon: Icons.qr_code_scanner,
            onTap: () async {
              final bookingId = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (_) => const ScanQrPage()),
              );

              if (bookingId != null && mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScanResultPage(bookingId: bookingId),
                  ),
                );
              }
            },
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
