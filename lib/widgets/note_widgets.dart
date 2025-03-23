import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../models/note.dart';
import '../providers/theme_provider.dart';

// Title Input Widget
class TitleInput extends StatelessWidget {
  final TextEditingController controller;

  const TitleInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: "Enter title here",
        labelText: "Title",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
        ),
      ),
    );
  }
}

// Content Input Widget
class ContentInput extends StatelessWidget {
  final TextEditingController controller;

  const ContentInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: "Content",
        hintText: "Enter content here",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
        ),
      ),
    );
  }
}

// Pick Color Button Widget
class PickColorButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PickColorButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Provider.of<ThemeProvider>(context).isDarkMode ?  Colors.white :  Colors.black,
          backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? const Color(0xFF001F47) : const Color(0xFF72A6CF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
            side: BorderSide(width: 1, color: Colors.black),
            alignment:Alignment.center,
        ),
        onPressed: onPressed,
        child: Text("Pick Note Color"),
      ),
    );
  }
}

//
class SaveChangesButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveChangesButton({super.key, required this.onPressed,}) ;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Provider.of<ThemeProvider>(context).isDarkMode ?  Colors.white :  Colors.black,
          backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? const Color(0xFF001F47) : const Color(0xFF72A6CF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
          side: const BorderSide(width: 1, color: Colors.black),
          alignment: Alignment.center,
        ),
        onPressed: onPressed,
        child: Text("Save Changes"),
      ),
    );
  }
}


// Pick Image Button Widget
class PickImageButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PickImageButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Provider.of<ThemeProvider>(context).isDarkMode ?  Colors.white :  Colors.black,
          backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? const Color(0xFF001F47) : const Color(0xFF72A6CF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
            side: BorderSide(width: 1, color: Colors.black),
            alignment:Alignment.center,
        ),
        onPressed: onPressed,
        child: Text("Pick Image"),
      ),
    );
  }
}

// Save Note Button Widget
class SaveNoteButton extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final Color selectedColor;
  final String? imagePath;

  const SaveNoteButton({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.selectedColor,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? const Color(0xFF001F47) : const Color(0xFF72A6CF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
            side: BorderSide(width: 1, color: Colors.black),
            alignment: Alignment.center,
        ),
        onPressed: () {
          if (titleController.text.trim().isEmpty ||
              contentController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Title and Content cannot be empty!"),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }

          final newNote = Note(
            title: titleController.text,
            content: contentController.text,
            createdAt: DateTime.now().toString(),
            colortheme: selectedColor.value,
            imagePath: imagePath,
          );

          Provider.of<NoteProvider>(context, listen: false).addNote(newNote);
          Navigator.pop(context);
        },
        child: Text("Save Note"),
      ),
    );
  }
}
