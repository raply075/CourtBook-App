import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_court_page.dart';
import '../../../court/presentation/providers/court_provider.dart';
import 'edit_court_page.dart';

class ManageCourtPage extends StatefulWidget {
  const ManageCourtPage({super.key});

  @override
  State<ManageCourtPage> createState() => _ManageCourtPageState();
}

class _ManageCourtPageState extends State<ManageCourtPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CourtProvider>().getCourts();
    });
  }

  Future<void> _deleteCourt(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Lapangan"),
        content: const Text("Apakah Anda yakin ingin menghapus lapangan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await context.read<CourtProvider>().deleteCourt(id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lapangan berhasil dihapus")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final courtProvider = context.watch<CourtProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Lapangan")),

      body: courtProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: courtProvider.courts.length,
              itemBuilder: (context, index) {
                final court = courtProvider.courts[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: court.imageUrl.isNotEmpty
                            ? Image.network(court.imageUrl, fit: BoxFit.cover)
                            : const Icon(Icons.sports_tennis),
                      ),
                    ),

                    title: Text(court.name),

                    subtitle: Text("${court.type}\nRp ${court.price}/jam"),

                    isThreeLine: true,

                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == "edit") {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditCourtPage(court: court),
                            ),
                          );

                          if (!mounted) return;

                          context.read<CourtProvider>().getCourts();
                        }

                        if (value == "delete") {
                          _deleteCourt(court.id!);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: "edit", child: Text("Edit")),
                        PopupMenuItem(value: "delete", child: Text("Hapus")),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCourtPage()),
          );
          if (!mounted) return;
          context.read<CourtProvider>().getCourts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
