import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../providers/theme_provider.dart';
import 'recycle_bin_screen.dart';
import 'add_note_screen.dart';
import 'note_detail_screen.dart';
import 'search_delegate.dart';
import 'date_filter.dart';
import 'dart:io';
import 'edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track selected tab (0 = Home, 1 = Favorites, 2 = Recycle Bin)

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context); // Access ThemeProvider

    List<Note> notes = [];
    String appBarTitle = "Notes";

    if (_selectedIndex == 0) {
      notes = noteProvider.notes; // Home (All Notes)
      appBarTitle = "Notes";
    } else if (_selectedIndex == 1) {
      notes = noteProvider.favorites; // Favorites
      appBarTitle = "Favorites";
    } else {
      notes = noteProvider.deletedNotes; // Recycle Bin
      appBarTitle = "Recycle Bin";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54, // Set color based on theme
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.date_range),
            color: themeProvider.isDarkMode ? Colors.orangeAccent : Colors.blueAccent, // Set color based on theme
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DateFilterScreen()),
              );
            },
          ),
          // Theme Toggle Button
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      
      body: notes.isEmpty
          ? Center(child: Text("No Notes Found!"))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Container(
                  color: Color(note.colortheme), // Apply selected note color
                  child: ListTile(
                    tileColor: Color(note.colortheme), // Apply selected note color
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding for better spacing
                    leading: Row(
                      mainAxisSize: MainAxisSize.min, // Ensures Row doesn’t take full space
                      children: [
                        // Pin Icon (always visible first)
                        IconButton(
                          icon: Icon(
                            note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                            color: note.isPinned ? Colors.orange : Colors.grey,
                          ),
                          onPressed: () => Provider.of<NoteProvider>(context, listen: false).togglePin(note),
                        ),

                        // If image exists, show it after the pin icon
                        if (note.imagePath != null && note.imagePath!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0), // Space between pin icon and image
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(note.imagePath!),
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                      ],
                    ),

                    title: Text(
                      note.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(
                      note.content.length > 30
                          ? '${note.content.substring(0, 30)}...'
                          : note.content,
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min, // Prevents row from taking full width
                      children: [
                        // Edit Icon
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditNoteScreen(note: note)),
                            );
                          },
                        ),

                        // Favorite Icon
                        IconButton(
                          icon: Icon(
                            note.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: note.isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => Provider.of<NoteProvider>(context, listen: false).toggleFavorite(note),
                        ),
                      ],
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NoteDetailScreen(note: note)),
                      );
                    },
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNoteScreen()));
        },
        child: Icon(Icons.add),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor, // Theme color applied
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Button
            IconButton(
              icon: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.white : Colors.white54),
              onPressed: () {
                setState(() => _selectedIndex = 0);
              },
            ),

            // Favorites Button
            IconButton(
              icon: Icon(Icons.favorite, color: _selectedIndex == 1 ? Colors.red : Colors.white54),
              onPressed: () {
                setState(() => _selectedIndex = 1);
              },
            ),

            // Recycle Bin Button
            IconButton(
              icon: Icon(Icons.delete, color: _selectedIndex == 2 ? Colors.white : Colors.white54),
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => RecycleBinScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
