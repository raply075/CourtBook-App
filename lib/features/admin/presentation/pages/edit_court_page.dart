import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../court/data/models/court_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../../../court/presentation/providers/court_provider.dart';

class EditCourtPage extends StatefulWidget {
  final CourtModel court;

  const EditCourtPage({super.key, required this.court});

  @override
  State<EditCourtPage> createState() => _EditCourtPageState();
}

class _EditCourtPageState extends State<EditCourtPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _descriptionController;

  late TextEditingController _priceController;

  late bool isAvailable;
  XFile? _image;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.court.name);
    _typeController = TextEditingController(text: widget.court.type);
    _descriptionController = TextEditingController(
      text: widget.court.description,
    );

    _priceController = TextEditingController(
      text: widget.court.price.toString(),
    );

    isAvailable = widget.court.isAvailable;
  }

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

  InputDecoration decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Future<void> _updateCourt() async {
    if (!_formKey.currentState!.validate()) return;
    String imageUrl = widget.court.imageUrl;

    if (_image != null) {
      final bytes = await _image!.readAsBytes();

      imageUrl = await context.read<CourtProvider>().uploadCourtImage(
        bytes,
        _image!.name,
      );
    }
    final court = CourtModel(
      id: widget.court.id,
      name: _nameController.text.trim(),
      type: _typeController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: imageUrl,
      price: int.parse(_priceController.text),
      isAvailable: isAvailable,
    );
    try {
      await context.read<CourtProvider>().updateCourt(court);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lapangan berhasil diperbarui")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourtProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Lapangan")),
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
                  child: _image != null
                      ? FutureBuilder<Uint8List>(
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
                        )
                      : widget.court.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.court.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Center(child: Icon(Icons.image, size: 60)),
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
                onChanged: (value) {
                  setState(() {
                    isAvailable = value;
                  });
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: provider.isLoading ? null : _updateCourt,
                  icon: const Icon(Icons.save),
                  label: const Text("Update"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
