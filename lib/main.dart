import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Notes/providers/theme_provider.dart';
import 'package:Notes/providers/note_provider.dart';
import 'package:Notes/screens/home_screen.dart';
import 'package:Notes/screens/intro_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFirstTime = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstTime = prefs.getBool("isFirstTime") ?? true;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Notes App",
            theme: themeProvider.themeData,
            home: isFirstTime ? const IntroScreen() : const HomeScreen(),
          );
        },
      ),
    );
  }
}
