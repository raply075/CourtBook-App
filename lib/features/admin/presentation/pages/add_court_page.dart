import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import '../../../court/data/models/court_model.dart';
import '../../../court/presentation/providers/court_provider.dart';
import 'package:image_picker/image_picker.dart';

class AddCourtPage extends StatefulWidget {
  const AddCourtPage({super.key});

  @override
  State<AddCourtPage> createState() => _AddCourtPageState();
}

class _AddCourtPageState extends State<AddCourtPage> {
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _priceController = TextEditingController();

  bool isAvailable = true;

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _descriptionController.dispose();

    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null) return;

    setState(() {
      _image = picked;
    });
  }

  Future<void> _saveCourt() async {
    if (!_formKey.currentState!.validate()) return;

    String imageUrl = "";

    if (_image != null) {
      final bytes = await _image!.readAsBytes();

      imageUrl = await context.read<CourtProvider>().uploadCourtImage(
        bytes,
        _image!.name,
      );
    }

    final court = CourtModel(
      name: _nameController.text.trim(),
      type: _typeController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: imageUrl,
      price: int.parse(_priceController.text),
      isAvailable: isAvailable,
    );

    try {
      await context.read<CourtProvider>().addCourt(court);

      print("BERHASIL INSERT");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lapangan berhasil ditambahkan")),
      );

      Navigator.pop(context);
    } catch (e) {
      print("ERROR INSERT = $e");

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

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _image == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 60),
                            SizedBox(height: 10),
                            Text("Pilih Gambar Lapangan"),
                          ],
                        )
                      : FutureBuilder<Uint8List>(
                          future: _image!.readAsBytes(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                ),
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
