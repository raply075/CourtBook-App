import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/admin_provider.dart';

class ScanResultPage extends StatefulWidget {
  final String bookingId;

  const ScanResultPage({super.key, required this.bookingId});

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AdminProvider>().getBookingById(widget.bookingId);
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  String formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminProvider>();
    final booking = provider.scannedBooking;

    if (booking == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Scan QR")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.sports_tennis),
                  title: const Text("Lapangan"),
                  subtitle: Text(booking.courtName ?? "-"),
                ),

                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text("Tanggal"),
                  subtitle: Text(formatDate(booking.bookingDate)),
                ),

                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text("Jam"),
                  subtitle: Text("${booking.startTime} - ${booking.endTime}"),
                ),

                ListTile(
                  leading: const Icon(Icons.payments),
                  title: const Text("Total"),
                  subtitle: Text(formatCurrency(booking.totalPrice)),
                ),

                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text("Status"),
                  subtitle: Text(booking.status),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle),
                    label: const Text(
                      "Confirm Booking",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      await provider.confirmBooking(booking.id!);

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Booking berhasil dikonfirmasi"),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
