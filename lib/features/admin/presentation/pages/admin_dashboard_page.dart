import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../court/presentation/pages/home_page.dart';
import '../providers/admin_provider.dart';
import 'manage_booking_page.dart';
import 'manage_court_page.dart';
import 'scan_qr_page.dart';
import 'scan_result_page.dart';
import '../widgets/booking_chart.dart';
import 'report_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void dispose() {
    context.read<AdminProvider>().stopRealtime();
    super.dispose();
  }

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

    Future.microtask(() {
      context.read<AdminProvider>().getDashboard();
    });

    Future.microtask(() {
      context.read<AdminProvider>().startRealtime();
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

  String rupiah(int value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  Widget StatisticCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(icon, size: 35, color: color),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(title),
            ],
          ),
        ),
      ),
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
    final admin = context.watch<AdminProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: admin.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  "Halo, Admin 👋",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 5),

                Text(
                  "Login sebagai : ${auth.role}",
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 25),

                if (admin.dashboard != null) ...[
                  Row(
                    children: [
                      StatisticCard(
                        icon: Icons.people,
                        title: "User",
                        value: admin.dashboard!.totalUsers.toString(),
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      StatisticCard(
                        icon: Icons.book_online,
                        title: "Booking",
                        value: admin.dashboard!.totalBookings.toString(),
                        color: Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      StatisticCard(
                        icon: Icons.sports_tennis,
                        title: "Lapangan",
                        value: admin.dashboard!.totalCourts.toString(),
                        color: Colors.green,
                      ),
                      const SizedBox(width: 10),
                      StatisticCard(
                        icon: Icons.payments,
                        title: "Pendapatan",
                        value: rupiah(admin.dashboard!.totalRevenue),
                        color: Colors.purple,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                ],
                const Text(
                  "Statistik Booking Mingguan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                const BookingChart(),

                const SizedBox(height: 25),
                menuCard(
                  icon: Icons.sports_tennis,
                  title: "Kelola Lapangan",
                  subtitle: "Tambah, edit dan hapus lapangan",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ManageCourtPage(),
                      ),
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
                      MaterialPageRoute(
                        builder: (_) => const ManageBookingPage(),
                      ),
                    );
                  },
                ),

                menuCard(
                  icon: Icons.qr_code_scanner,
                  title: "Scan QR",
                  subtitle: "Scan QR Booking pengguna",
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
                menuCard(
                  icon: Icons.picture_as_pdf,
                  title: "Laporan PDF",
                  subtitle: "Cetak laporan booking",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReportPage()),
                    );
                  },
                ),
                menuCard(
                  icon: Icons.person,
                  title: "Profile Admin",
                  subtitle: "Lihat dan edit profil",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                ),
                menuCard(
                  icon: Icons.table_chart,
                  title: "Export Excel",
                  subtitle: "Download laporan booking",
                  onTap: () async {
                    await admin.exportExcel();
                  },
                ),
              ],
            ),
    );
  }
}
