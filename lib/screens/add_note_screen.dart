import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../widgets/note_widgets.dart'; 
import '../widgets/color_picker.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  
  Color selectedColor = Colors.white;
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _pickColor() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Note")),
      backgroundColor: selectedColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:Container(
        color: selectedColor,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TitleInput(controller: titleController), // Reused Widget
            SizedBox(height: 10),
            ContentInput(controller: contentController), // Reused Widget
            SizedBox(height: 20),

            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 200, width: double.infinity, fit: BoxFit.contain),

            SizedBox(height: 20),

            Row(
              children: [
                PickImageButton(onPressed: _pickImage), // Reused Widget
                SizedBox(width: 11),
                PickColorButton(onPressed: _pickColor), // Reused Widget
                SizedBox(width: 11),
                SaveNoteButton( // Reused Widget
                  titleController: titleController,
                  contentController: contentController,
                  selectedColor: selectedColor,
                  imagePath: _selectedImage?.path,
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
