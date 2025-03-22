import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import 'edit_note_screen.dart'; 
import 'dart:io';

class NoteDetailScreen extends StatelessWidget {
  final Note note;
  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note Details"),
        actions: [
          // Edit Icon
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              // Navigate to EditNoteScreen and wait for result
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNoteScreen(note: note),
                ),
              );
            },
          ),
          // Delete Icon
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Provider.of<NoteProvider>(context, listen: false).moveToTrash(note.id!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      
      // Consumer to dynamically update the note on the screen
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) {
          final updatedNote = noteProvider.notes.firstWhere((n) => n.id == note.id, orElse: () => note);

          return Container(
            color: Color(updatedNote.colortheme), // Updated color dynamically
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: updatedNote.imagePath == null || updatedNote.imagePath!.isEmpty 
                ? MainAxisAlignment.start // Center text only if no image
                : MainAxisAlignment.start, // Start alignment if image exists
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Show Image if it exists
                if (updatedNote.imagePath != null && updatedNote.imagePath!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(updatedNote.imagePath!),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),

                SizedBox(height: 20),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    updatedNote.title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center, 
                  ),
                ),
                SizedBox(height: 10),

                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    updatedNote.content,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,  
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
