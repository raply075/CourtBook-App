import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/models/profile_model.dart';
import '../providers/profile_provider.dart';
import 'package:flutter/foundation.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  Uint8List? _imageBytes;
  XFile? _image;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = context.read<ProfileProvider>();

      await provider.getProfile();

      if (!mounted) return;

      final profile = provider.profile;

      if (profile != null) {
        _nameController.text = profile.fullName;
        _phoneController.text = profile.phone ?? "";
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    setState(() {
      _image = picked;
      _imageBytes = bytes;
    });
  }

  Future<void> _save() async {
    final provider = context.read<ProfileProvider>();

    final oldProfile = provider.profile;

    print("SAVE DITEKAN");

    if (oldProfile == null) return;

    String? avatar = oldProfile.avatarUrl;

    if (_image != null) {
      print("UPLOAD FOTO");
      final bytes = await _image!.readAsBytes();

      avatar = await provider.uploadAvatar(bytes, _image!.name);
    }

    print("UPDATE PROFILE");

    final profile = ProfileModel(
      id: oldProfile.id,
      fullName: _nameController.text.trim(),
      email: oldProfile.email,
      phone: _phoneController.text.trim(),
      avatarUrl: avatar,
      role: oldProfile.role,
    );

    await provider.updateProfile(profile);

    print("SELESAI");

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Profil berhasil diperbarui")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final profile = provider.profile;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _imageBytes != null
                              ? MemoryImage(_imageBytes!)
                              : (profile?.avatarUrl != null &&
                                    profile!.avatarUrl!.isNotEmpty)
                              ? NetworkImage(profile.avatarUrl!)
                              : null,
                          child:
                              (_image == null &&
                                  (profile?.avatarUrl == null ||
                                      profile!.avatarUrl!.isEmpty))
                              ? const Icon(Icons.person, size: 60)
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Nama Lengkap",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Nomor HP",
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: provider.isLoading ? null : _save,
                      child: provider.isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              "SIMPAN",
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
