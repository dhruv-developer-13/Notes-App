import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteTile extends StatelessWidget {
  final Note note;

  const NoteTile({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          note.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          note.content.length > 30
              ? '${note.content.substring(0, 30)}...'
              : note.content,
        ),
        onTap: () {
          // Navigate to full note view (You can implement later)
        },
      ),
    );
  }
}
