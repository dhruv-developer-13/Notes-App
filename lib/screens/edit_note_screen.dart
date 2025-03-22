import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../widgets/note_widgets.dart';
import '../widgets/color_picker.dart';
import 'dart:io';

class EditNoteScreen extends StatefulWidget {
  final Note note;
  const EditNoteScreen({super.key, required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late Color selectedColor;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    contentController = TextEditingController(text: widget.note.content);
    selectedColor = Color(widget.note.colortheme);
    if (widget.note.imagePath != null) {
      _selectedImage = File(widget.note.imagePath!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    // Using MediaQuery for height calculation and screen size constraints
    double minHeight = MediaQuery.of(context).size.height * 0.4; // Minimum height for the screen

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
      ),
      backgroundColor: selectedColor,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(), // Clamping physics for better scrolling behavior
        child: Container(
          padding: EdgeInsets.all(16.0),
          constraints: BoxConstraints(minHeight: minHeight), // Set minimum height
          child: Column(
            children: [
              if (_selectedImage != null)
                Image.file(
                  _selectedImage!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                ),

              SizedBox(height: 20),

              // Reusable Title Field Widget
              TitleInput(controller: titleController),

              SizedBox(height: 20),

              // Reusable Content Field Widget
              ContentInput(controller: contentController),

              SizedBox(height: 20),

              Row(
                children: [
                  // Reusable Pick Color Button
                  PickColorButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ColorPickerWidget(
                          initialColor: selectedColor,
                          onColorSelected: (color) {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                        ),
                      );
                    },
                  ),

                  SizedBox(width: 11),

                  // Save Changes Button
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        side: BorderSide(width: 1, color: Colors.black),
                        alignment:Alignment.center,
                      ),
                      onPressed: () {
                        final updatedNote = widget.note.copyWith(
                          title: titleController.text,
                          content: contentController.text,
                          colortheme: selectedColor.value,
                        );

                        noteProvider.updateNote(updatedNote);  // Update the note
                        Navigator.pop(context); // Return to previous screen
                      },
                      child: Text("Save Changes"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
