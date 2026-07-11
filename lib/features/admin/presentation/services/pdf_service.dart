import 'package:pdf/widgets.dart' as pw;
import '../../../booking/data/models/booking_model.dart';

class PdfService {
  Future<pw.Document> generate(List<BookingModel> bookings) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            "Laporan Booking CourtBook",
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 20),

          pw.Table.fromTextArray(
            headers: const ["Lapangan", "Tanggal", "Jam", "Status", "Harga"],

            data: bookings
                .map(
                  (e) => [
                    e.courtName ?? "-",
                    e.bookingDate.toString().split(" ").first,
                    "${e.startTime}-${e.endTime}",
                    e.status,
                    "Rp ${e.totalPrice}",
                  ],
                )
                .toList(),
          ),
        ],
      ),
    );

    return pdf;
  }
}
