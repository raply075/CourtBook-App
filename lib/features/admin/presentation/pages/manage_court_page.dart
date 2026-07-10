import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_court_page.dart';
import '../../../court/presentation/providers/court_provider.dart';

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
                    leading: const CircleAvatar(
                      child: Icon(Icons.sports_tennis),
                    ),

                    title: Text(court.name),

                    subtitle: Text("${court.type}\nRp ${court.price}/jam"),

                    isThreeLine: true,

                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "edit") {
                          // STEP berikutnya
                        }

                        if (value == "delete") {
                          // STEP berikutnya
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
