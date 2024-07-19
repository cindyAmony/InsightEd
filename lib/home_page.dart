import 'package:flutter/material.dart';
import 'webview_page.dart';
import 'text_to_speech.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextToSpeech tts = TextToSpeech();

  @override
  void initState() {
    super.initState();
    tts.initTts().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        tts.speak('Insight Ed is an innovative mobile application designed to revolutionize the learning experience for visually impaired students in higher education. By seamlessly integrating with Moodle-based Learning Management Systems.');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(19, 255, 255, 255),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Insight Ed',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 50),
              Image.asset('assets/insightEd.png', height: 100), // Add your logo here
              const SizedBox(height: 20),
              const Text(
                'InsightEd is an innovative mobile application designed to revolutionize the learning experience for visually impaired students in higher education. By seamlessly integrating with Moodle-based Learning Management Systems (LMS).',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 120),
              ElevatedButton(
                onPressed: () async {
                  await tts.speak('Opening Portal'); // Speak message before navigating
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WebViewPage()),
                  );
                },
                child: const Text('Open Portal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
