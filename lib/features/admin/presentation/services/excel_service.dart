import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;

import '../../../booking/data/models/booking_model.dart';

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

    final bytes = excel.encode();

    if (bytes == null) return;

    if (kIsWeb) {
      final blob = html.Blob([Uint8List.fromList(bytes)]);

      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: url)
        ..setAttribute("download", "booking_report.xlsx")
        ..click();

      html.Url.revokeObjectUrl(url);
    } else {
      await Share.shareXFiles([
        XFile.fromData(
          Uint8List.fromList(bytes),
          mimeType:
              "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
          name: "booking_report.xlsx",
        ),
      ]);
    }
  }
}
