import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../data/datasources/admin_remote_datasource.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../services/pdf_service.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    generatePdf();
  }

  Future<void> generatePdf() async {
    final repository = AdminRepositoryImpl(AdminRemoteDataSource());

    final bookings = await repository.getReportBookings();

    final pdf = await PdfService().generate(bookings);

    await Printing.layoutPdf(onLayout: (_) async => pdf.save());

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generate Laporan")),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
