import 'package:flutter/material.dart';

// Light Theme
ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF72A6CF), brightness: Brightness.light),
  useMaterial3: true,
  primaryColor: const Color(0xFF72A6CF),
  scaffoldBackgroundColor: const Color.fromARGB(240, 255, 255, 255),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.black), // Text color for light mode
    bodyLarge: TextStyle(color: Colors.black87), // Slightly darker text
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF72A6CF),
    foregroundColor: Colors.white,
  ),
);

// Dark Theme
ThemeData darkTheme = ThemeData(
  
  useMaterial3: true,
  primaryColor: const Color(0xFF001F47),
  scaffoldBackgroundColor: Color(0xFF1E2A3A),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.black), // Text color for light mode
    bodyLarge: TextStyle(color: Colors.black87), // Slightly darker text
  ),
  appBarTheme: AppBarTheme(
    backgroundColor:  const Color(0xFF001F47),
    foregroundColor: Colors.white,
  ),
);
