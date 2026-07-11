import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import 'booking_detail_page.dart';
import 'upload_payment_page.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
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
  void initState() {
    super.initState();

    Future.microtask(() {
      final auth = context.read<AuthProvider>();
      final bookingProvider = context.read<BookingProvider>();

      final user = auth.currentUser;

      if (user != null) {
        bookingProvider.getBookingHistory(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Booking Saya")),
      body: bookingProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookingProvider.bookingHistory.isEmpty
          ? const Center(child: Text("Belum ada booking"))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: bookingProvider.bookingHistory.length,
              itemBuilder: (context, index) {
                final booking = bookingProvider.bookingHistory[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingDetailPage(booking: booking),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.sports_tennis,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  booking.courtName ?? "Lapangan",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18),
                              const SizedBox(width: 8),
                              Text(formatDate(booking.bookingDate)),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 18),
                              const SizedBox(width: 8),
                              Text("${booking.startTime} - ${booking.endTime}"),
                            ],
                          ),

                          const SizedBox(height: 15),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor(
                                booking.status,
                              ).withOpacity(.15),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  statusIcon(booking.status),
                                  size: 18,
                                  color: statusColor(booking.status),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  booking.status,
                                  style: TextStyle(
                                    color: statusColor(booking.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                formatCurrency(booking.totalPrice),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          if (booking.status == "Confirmed")
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.upload),
                                label: const Text("Upload Bukti Pembayaran"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => UploadPaymentPage(
                                        bookingId: booking.id!,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
