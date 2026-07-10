import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../court/data/models/court_model.dart';
import '../../../court/presentation/providers/court_provider.dart';

class AddCourtPage extends StatefulWidget {
  const AddCourtPage({super.key});

  @override
  State<AddCourtPage> createState() => _AddCourtPageState();
}

class _AddCourtPageState extends State<AddCourtPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  final _priceController = TextEditingController();

  bool isAvailable = true;

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveCourt() async {
    if (!_formKey.currentState!.validate()) return;

    final court = CourtModel(
      name: _nameController.text.trim(),
      type: _typeController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: _imageController.text.trim(),
      price: int.parse(_priceController.text),
      isAvailable: isAvailable,
    );

    try {
      await context.read<CourtProvider>().addCourt(court);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lapangan berhasil ditambahkan")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  InputDecoration decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourtProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Lapangan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: decoration("Nama Lapangan"),
                validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _typeController,
                decoration: decoration("Jenis Lapangan"),
                validator: (v) => v!.isEmpty ? "Jenis wajib diisi" : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _descriptionController,
                decoration: decoration("Deskripsi"),
                maxLines: 3,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _imageController,
                decoration: decoration("Image URL"),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: decoration("Harga / Jam"),
                validator: (v) => v!.isEmpty ? "Harga wajib diisi" : null,
              ),

              const SizedBox(height: 15),

              SwitchListTile(
                title: const Text("Lapangan Tersedia"),
                value: isAvailable,
                onChanged: (v) {
                  setState(() {
                    isAvailable = v;
                  });
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: provider.isLoading ? null : _saveCourt,
                  icon: const Icon(Icons.save),
                  label: const Text("Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
