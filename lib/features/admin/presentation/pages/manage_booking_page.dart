import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/admin_provider.dart';

class ManageBookingPage extends StatefulWidget {
  const ManageBookingPage({super.key});

  @override
  State<ManageBookingPage> createState() => _ManageBookingPageState();
}

final TextEditingController searchController = TextEditingController();
String keyword = "";
String selectedStatus = "Semua";

class _ManageBookingPageState extends State<ManageBookingPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AdminProvider>().getAllBookings();
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  Color statusColor(String status) {
    switch (status) {
      case "Confirmed":
        return Colors.green;

      case "Rejected":
        return Colors.red;

      case "Cancelled":
        return Colors.red;

      case "Completed":
        return Colors.blue;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminProvider>();

    final filtered = provider.bookings.where((booking) {
      final court = (booking.courtName ?? "").toLowerCase();
      final status = booking.status.toLowerCase();

      final matchSearch = court.contains(keyword) || status.contains(keyword);

      final matchStatus =
          selectedStatus == "Semua" || booking.status == selectedStatus;

      return matchSearch && matchStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Booking")),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Cari lapangan atau status...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        keyword = value.toLowerCase();
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      labelText: "Filter Status",
                    ),
                    items: const [
                      DropdownMenuItem(value: "Semua", child: Text("Semua")),
                      DropdownMenuItem(
                        value: "Pending",
                        child: Text("Pending"),
                      ),
                      DropdownMenuItem(
                        value: "Confirmed",
                        child: Text("Confirmed"),
                      ),
                      DropdownMenuItem(
                        value: "Rejected",
                        child: Text("Rejected"),
                      ),
                      DropdownMenuItem(
                        value: "Completed",
                        child: Text("Completed"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await provider.getAllBookings();
                    },
                    child: filtered.isEmpty
                        ? const Center(child: Text("Booking tidak ditemukan"))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final booking = filtered[index];

                              return Card(
                                margin: const EdgeInsets.only(bottom: 15),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        booking.courtName ?? "Lapangan",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today),
                                          const SizedBox(width: 8),
                                          Text(formatDate(booking.bookingDate)),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      Row(
                                        children: [
                                          const Icon(Icons.access_time),
                                          const SizedBox(width: 8),
                                          Text(
                                            "${booking.startTime} - ${booking.endTime}",
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor(
                                            booking.status,
                                          ).withOpacity(.15),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                        child: Text(
                                          booking.status,
                                          style: TextStyle(
                                            color: statusColor(booking.status),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),

                                      if (booking.paymentProof != null &&
                                          booking.paymentProof!.isNotEmpty) ...[
                                        const Text(
                                          "Bukti Pembayaran",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            booking.paymentProof!,
                                            height: 220,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ] else
                                        const Text(
                                          "Belum upload bukti pembayaran",
                                        ),

                                      const SizedBox(height: 15),
                                      const SizedBox(height: 18),

                                      // ============================
                                      // BOOKING BARU
                                      // ============================
                                      if (booking.status == "Pending")
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                ),
                                                onPressed: () async {
                                                  await provider.confirmBooking(
                                                    booking.id!,
                                                  );

                                                  if (!mounted) return;

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Booking berhasil dikonfirmasi",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.check),
                                                label: const Text("Confirm"),
                                              ),
                                            ),

                                            const SizedBox(width: 10),

                                            Expanded(
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                onPressed: () async {
                                                  await provider.rejectBooking(
                                                    booking.id!,
                                                  );

                                                  if (!mounted) return;

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Booking ditolak",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.close),
                                                label: const Text("Reject"),
                                              ),
                                            ),
                                          ],
                                        )
                                      // ============================
                                      // SUDAH KONFIRMASI & USER SUDAH BAYAR
                                      // ============================
                                      else if (booking.status == "Confirmed" &&
                                          booking.paymentProof != null &&
                                          booking.paymentProof!.isNotEmpty)
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                ),
                                                onPressed: () async {
                                                  await provider
                                                      .completeBooking(
                                                        booking.id!,
                                                      );

                                                  if (!mounted) return;

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Pembayaran berhasil disetujui",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.verified,
                                                ),
                                                label: const Text(
                                                  "Approve Pembayaran",
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 10),

                                            Expanded(
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                onPressed: () async {
                                                  await provider.rejectBooking(
                                                    booking.id!,
                                                  );

                                                  if (!mounted) return;

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        "Pembayaran ditolak",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.close),
                                                label: const Text("Tolak"),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
    );
  }
}
