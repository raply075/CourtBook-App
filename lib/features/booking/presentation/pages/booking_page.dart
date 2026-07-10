import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../../data/models/booking_model.dart';
import '../../../court/data/models/court_model.dart';

class BookingPage extends StatefulWidget {
  final CourtModel court;

  const BookingPage({super.key, required this.court});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? selectedDate;

  TimeOfDay? startTime;

  TimeOfDay? endTime;

  Future<void> _createBooking() async {
    if (selectedDate == null || startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data booking")),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final bookingProvider = context.read<BookingProvider>();

    final user = auth.currentUser;

    if (user == null) return;

    final booking = BookingModel(
      userId: user.id,
      courtId: widget.court.id,
      bookingDate: selectedDate!,
      startTime:
          "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}:00",
      endTime:
          "${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}:00",
      totalPrice: widget.court.price,
    );

    try {
      await bookingProvider.createBooking(booking);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Booking berhasil")));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking Lapangan")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              widget.court.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(widget.court.type),

            const SizedBox(height: 30),

            ListTile(
              leading: const Icon(Icons.calendar_today),

              title: Text(
                selectedDate == null
                    ? "Pilih Tanggal"
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              ),

              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  initialDate: DateTime.now(),
                );

                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.access_time),

              title: Text(
                startTime == null ? "Jam Mulai" : startTime!.format(context),
              ),

              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (time != null) {
                  setState(() {
                    startTime = time;
                  });
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.access_time_filled),

              title: Text(
                endTime == null ? "Jam Selesai" : endTime!.format(context),
              ),

              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (time != null) {
                  setState(() {
                    endTime = time;
                  });
                }
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createBooking,
                child: const Text("Lanjut Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
