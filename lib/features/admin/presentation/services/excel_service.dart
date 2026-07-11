import 'dart:io';

import 'package:courtbook/features/booking/data/models/booking_model.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExcelService {
  static Future<void> exportBookings(List<BookingModel> bookings) async {
    final excel = Excel.createExcel();

    final sheet = excel['Bookings'];

    sheet.appendRow([
      TextCellValue("Tanggal"),
      TextCellValue("Lapangan"),
      TextCellValue("Jam"),
      TextCellValue("Status"),
      TextCellValue("Harga"),
    ]);

    for (final booking in bookings) {
      sheet.appendRow([
        TextCellValue(booking.bookingDate.toString().split(" ")[0]),

        TextCellValue(booking.courtName ?? "-"),

        TextCellValue("${booking.startTime} - ${booking.endTime}"),

        TextCellValue(booking.status),

        IntCellValue(booking.totalPrice),
      ]);
    }

    final dir = await getTemporaryDirectory();

    final file = File("${dir.path}/booking_report.xlsx");

    await file.writeAsBytes(excel.encode()!);

    Share.shareXFiles([XFile(file.path)], text: "Laporan Booking");
  }
}
