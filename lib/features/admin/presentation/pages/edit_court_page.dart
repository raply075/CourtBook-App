import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../court/data/models/court_model.dart';
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
  late TextEditingController _imageController;
  late TextEditingController _priceController;

  late bool isAvailable;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.court.name);
    _typeController = TextEditingController(text: widget.court.type);
    _descriptionController = TextEditingController(
      text: widget.court.description,
    );
    _imageController = TextEditingController(text: widget.court.imageUrl);
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
    _imageController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  InputDecoration decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Future<void> _updateCourt() async {
    if (!_formKey.currentState!.validate()) return;

    final court = CourtModel(
      id: widget.court.id,
      name: _nameController.text.trim(),
      type: _typeController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: _imageController.text.trim(),
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
