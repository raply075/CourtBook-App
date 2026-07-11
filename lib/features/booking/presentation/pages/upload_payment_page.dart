import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/booking_provider.dart';

class UploadPaymentPage extends StatefulWidget {
  final String bookingId;

  const UploadPaymentPage({super.key, required this.bookingId});

  @override
  State<UploadPaymentPage> createState() => _UploadPaymentPageState();
}

class _UploadPaymentPageState extends State<UploadPaymentPage> {
  File? image;

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final result = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (result == null) return;

    setState(() {
      image = File(result.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Upload Bukti Pembayaran")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: image == null
                    ? const Text(
                        "Belum memilih gambar",
                        style: TextStyle(fontSize: 18),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(image!),
                      ),
              ),
            ),

            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.photo),
              label: const Text("Pilih Gambar"),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                label: booking.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Upload"),
                onPressed: image == null
                    ? null
                    : () async {
                        await booking.uploadPaymentProof(
                          widget.bookingId,
                          image!,
                        );

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Upload berhasil")),
                        );

                        Navigator.pop(context);
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
