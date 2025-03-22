import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isLoaded = true;
    });
  }

  Future<void> _completeIntro(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isFirstTime", false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoaded
          ? SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // Centers content horizontally
                    children: [
                      Expanded(
                        child: IntroductionScreen(
                          pages: [
                            _buildPage(
                              title: "Welcome to Notes App",
                              body: "Save and organize your notes efficiently.",
                              icon: Icons.note,
                              iconColor: Colors.blue,
                            ),
                            _buildPage(
                              title: "Stay Organized",
                              body: "Pin important notes to keep them on top and never miss them.",
                              icon: Icons.push_pin,
                              iconColor: Colors.orange,
                            ),
                            _buildPage(
                              title: "Quick Access to Important Notes",
                              body: "Mark your favorite notes for instant access.",
                              icon: Icons.favorite,
                              iconColor: Colors.red,
                            ),
                            _buildPage(
                              title: "Customize Your Experience",
                              body: "Choose different themes for your notes to make them stand out.",
                              icon: Icons.color_lens,
                              iconColor: Colors.purple,
                            ),
                            _buildPage(
                              title: "Dark or Light? You Decide!",
                              body: "Switch between Dark and Light modes to suit your preference.",
                              icon: Icons.brightness_6,
                              iconColor: Colors.teal,
                            ),
                            _buildPage(
                              title: "Filter Notes by Date",
                              body: "Select a date to view your notes from that day.",
                              icon: Icons.date_range,
                              iconColor: Colors.blueGrey,
                            ),
                            _buildPage(
                              title: "Search Notes",
                              body: "Easily search your notes by title or content.",
                              icon: Icons.search,
                              iconColor: Colors.blueAccent,
                            ),
                            _buildPage(
                              title: "Recover Deleted Notes",
                              body: "Accidentally deleted a note? Restore it from the Recycle Bin.",
                              icon: Icons.delete,
                              iconColor: Colors.grey,
                            ),
                          ],
                          done: const Text("Get Started"),
                          onDone: () => _completeIntro(context),
                          next: const Text("Next"),
                          skip: const Text("Skip"),
                          showSkipButton: true,
                          onSkip: () => _completeIntro(context),
                          dotsDecorator: DotsDecorator(
                            activeSize: const Size(10.0, 10.0), // Keeping dots slightly bigger
                            size: const Size(4.35, 4.35),
                          ),
                          controlsPadding: const EdgeInsets.symmetric(horizontal: 1,vertical: 15), // Reduced horizontal space
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  PageViewModel _buildPage({
  required String title,
  required String body,
  required IconData icon,
  required Color iconColor,
}) {
  return PageViewModel(
    title: "",
    bodyWidget: SizedBox(
      height: MediaQuery.of(context).size.height * 0.6, // Fixes height to 60% of screen
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Ensures content is vertically centered
        crossAxisAlignment: CrossAxisAlignment.center, // Ensures horizontal centering
        children: [
          Icon(icon, size: 100, color: iconColor), // Centered Icon
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    ),
  );
}
}
