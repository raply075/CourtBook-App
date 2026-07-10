import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../data/models/booking_model.dart';

class BookingQrPage extends StatelessWidget {
  final BookingModel booking;

  const BookingQrPage({super.key, required this.booking});

  String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Booking")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.qr_code_2, size: 60, color: Colors.green),

                  const SizedBox(height: 15),

                  const Text(
                    "QR Booking",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 30),

                  QrImageView(
                    data: booking.id ?? "",
                    version: QrVersions.auto,
                    size: 240,
                  ),

                  const SizedBox(height: 25),

                  Text(
                    booking.courtName ?? "Lapangan",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(formatDate(booking.bookingDate)),

                  const SizedBox(height: 5),

                  Text("${booking.startTime} - ${booking.endTime}"),

                  const SizedBox(height: 20),

                  const Text(
                    "Booking ID",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  SelectableText(
                    booking.id ?? "-",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
