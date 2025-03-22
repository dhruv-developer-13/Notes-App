import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatefulWidget {
  final Color initialColor;
  final Function(Color) onColorSelected;

  const ColorPickerWidget({super.key, required this.initialColor, required this.onColorSelected});

  @override
  _ColorPickerWidgetState createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late Color selectedColor;

  // Define lighter cold colors (Light Blue, Teal, etc.)
  List<Color> coldColors = [
    //cool blue shades
    Color(0xFF76D7EA), // Soft Sky Blue  
    Color(0xFFA7C7E7), // Pastel Blue  
    Color(0xFFCCCCFF), // Periwinkle  
    Color(0xFFE0FFFF), // Light Cyan  
    Color(0xFF72A0C1), // Muted Blue  
    Color(0xFF7CB9E8), // Pale Azure  
    Color(0xFF71A6D2), // Icy Blue  
    Color(0xFFB9D9EB), // Glacier Blue  
    Color(0xFFADD8E6), // LightBlue
    Color(0xFFB0E0E6), // PowderBlue 
    Color(0xFFF0FFFF),  // Azure
    Color(0xFFF0F8FF),  // AliceBlue
    Color(0xFFAFEEEE),  // PaleTurquoise
    Color(0xFF87CEEB),  // SkyBlue
    Color(0xFF00FFFF), // Aqua

    //cool pink shades
    Color(0xFFFFD1DC), // Cherry Blossom Pink  
    Color(0xFFFFE5EC), // Light Rose  
    Color(0xFFFFCFCB), // Soft Pink  
    Color(0xFFFFDDE6), // Pearl Pink  
    Color(0xFFFFDAB9), // Peachy Pink  
    Color(0xFFFFE6E8), // Cotton Pink  
    Color(0xFFFFD3E0), // Powder Pink  
    Color(0xFFFFC1E0), // Pastel Pink  

    //cool lavender shades
    Color(0xFFD8BFD8), // Thistle  
    Color(0xFFE6E6FA), // Lavender  
    Color(0xFFB39DDB), // Light Purple  
    Color(0xFFCAB2D6), // Pastel Lilac  
    Color(0xFFDDA0DD), // Soft Plum  
    Color(0xFFE3C1E3), // Cloudy Lavender  
    Color(0xFFE0BBE4), // Gentle Orchid  
    Color(0xFFE5CCFF), // Pale Violet  
    Color(0xFFEEDCFF), // Muted Purple  

    //cool green shades
    Color(0xFF98FB98), // Pale Green  
    Color(0xFF90EE90), // Light Green  
    Color(0xFFA8E6CF), // Mint Green  
    Color(0xFFB5EAD7), // Pastel Mint  
    Color(0xFF99EDC3), // Cool Mint  
    Color(0xFFB2F5EA), // Ice Mint  
    Color(0xFFACE1AF), // Celadon Green  
    Color(0xFFCBF3F0), // Aqua Mint  
    Color(0xFFD0F0C0), // Tea Green  
  ];

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Pick a color"),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: selectedColor,
          availableColors: coldColors,  // Use the cold colors array
          onColorChanged: (color) {
            setState(() {
              selectedColor = color;
            });
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text("Done"),
          onPressed: () {
            widget.onColorSelected(selectedColor);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
