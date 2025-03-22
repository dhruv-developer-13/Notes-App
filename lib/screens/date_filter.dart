import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../providers/theme_provider.dart';
import '../models/note.dart'; 
import 'note_detail_screen.dart'; 

class DateFilterScreen extends StatefulWidget {
  const DateFilterScreen({super.key});

  @override
  _DateFilterScreenState createState() => _DateFilterScreenState();
}

class _DateFilterScreenState extends State<DateFilterScreen> {
  DateTime? selectedDate;
  List<Note> filteredNotes = [];

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Filter Notes by Date"),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () async {
              // Show a date picker to allow the user to select a date
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  selectedDate = pickedDate;
                });

                // Filter the notes by the selected date
                filteredNotes = noteProvider.notes
                    .where((note) {
                      // Parse the createdAt string into DateTime and compare
                      DateTime noteDate = DateTime.parse(note.createdAt);
                      return noteDate.year == selectedDate!.year &&
                          noteDate.month == selectedDate!.month &&
                          noteDate.day == selectedDate!.day;
                    })
                    .toList();
              }
            },
          ),
        ],
      ),
      body: selectedDate == null
          ? Center(
              child: Text(
                "Please select a date to filter",
                style: TextStyle(
                  color: Provider.of<ThemeProvider>(context).isDarkMode
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
            )
          : filteredNotes.isEmpty
              ? Center(child: Text("No notes found for the selected date",
              style: TextStyle(
                  color: Provider.of<ThemeProvider>(context).isDarkMode
                      ? Colors.white70
                      : Colors.black54,
                ),))
              : ListView.builder(
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = filteredNotes[index];
                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.content),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteDetailScreen(note: note),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
