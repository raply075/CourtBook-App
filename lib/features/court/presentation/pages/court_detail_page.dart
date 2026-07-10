import 'package:flutter/material.dart';
import '../../../booking/presentation/pages/booking_page.dart';
import '../../data/models/court_model.dart';

class CourtDetailPage extends StatelessWidget {
  final CourtModel court;

  const CourtDetailPage({super.key, required this.court});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(court.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              court.imageUrl,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 220,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image, size: 80),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    court.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    court.type,
                    style: const TextStyle(fontSize: 18, color: Colors.blue),
                  ),

                  const SizedBox(height: 20),

                  Text(court.description, style: const TextStyle(fontSize: 16)),

                  const SizedBox(height: 30),

                  Text(
                    "Rp ${court.price} / Jam",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingPage(court: court),
                          ),
                        );
                      },
                      child: const Text("Booking Sekarang"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
