import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/booking_model.dart';
import 'booking_qr_page.dart';

class BookingDetailPage extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailPage({super.key, required this.booking});

  String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  String formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(amount);
  }

  Color statusColor(String status) {
    switch (status) {
      case "Confirmed":
        return Colors.green;
      case "Rejected":
      case "Cancelled":
        return Colors.red;
      case "Completed":
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case "Confirmed":
        return Icons.check_circle;
      case "Rejected":
      case "Cancelled":
        return Icons.cancel;
      case "Completed":
        return Icons.verified;
      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Booking")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.sports_tennis,
                    size: 40,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  booking.courtName ?? "Lapangan",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

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
                  title: const Text("Total Pembayaran"),
                  subtitle: Text(formatCurrency(booking.totalPrice)),
                ),

                ListTile(
                  leading: Icon(
                    statusIcon(booking.status),
                    color: statusColor(booking.status),
                  ),
                  title: const Text("Status"),
                  subtitle: Text(
                    booking.status,
                    style: TextStyle(
                      color: statusColor(booking.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Divider(height: 35),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code),
                    label: const Text("Lihat QR Booking"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingQrPage(booking: booking),
                        ),
                      );
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
