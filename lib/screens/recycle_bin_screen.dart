import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';

class RecycleBinScreen extends StatelessWidget {
  const RecycleBinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final deletedNotes = noteProvider.deletedNotes; // Corrected variable

    return Scaffold(
      appBar: AppBar(title: Text("Recycle Bin")),
      body: deletedNotes.isEmpty
          ? Center(child: Text("No deleted notes"))
          : ListView.builder(
              itemCount: deletedNotes.length,
              itemBuilder: (context, index) {
                final note = deletedNotes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text("Deleted on: ${note.createdAt}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.restore, color: Colors.green),
                        onPressed: () {
                          noteProvider.restoreNoteFromTrash(note.id!);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          noteProvider.deleteNotePermanently(note.id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
