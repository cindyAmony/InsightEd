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
  String? selectedVoice;
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    loadVoices();
  }

  void loadVoices() async {
    List<Map<String, dynamic>> voices = await tts.getAvailableVoices();
    setState(() {
      // Default selected voice when loading voices
      if (voices.isNotEmpty) {
        selectedVoice = voices.first['locale']; // Default to first voice
      }
    });
  }

  void toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  void onVoiceSelected(String? voiceName) {
    setState(() {
      selectedVoice = voiceName;
    });

    // Make sure voiceName is not null before setting the voice
    if (voiceName != null) {
      tts.setVoice(voiceName); // Set the selected voice
    } else {
      // Handle the case where voiceName is null (if needed)
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(19, 255, 255, 255),
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 10),
                  child: DropdownButton<String>(
                    value: selectedVoice,
                    onChanged: onVoiceSelected,
                    items: tts.targetVoices.map((voice) {
                      return DropdownMenuItem<String>(
                        value: voice['locale'], // Use locale as value
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(voice['locale']!), // Display locale
                            Text(voice['gender'] == 'female'
                                ? 'F'
                                : 'M'), // Gender indicator
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await tts.speak('Hey there, its a new Day !');
                  },
                  child: const Text('Test Voice'),
                ),
                const Spacer(),
                Column(
                  children: [
                    const Text(
                      'Insight Ed',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Image.asset('assets/insightEd.png',
                        height: 100), // Add your logo here
                    const SizedBox(height: 20),
                    const Text(
                      'InsightEd is an innovative mobile application designed to revolutionize the learning experience for visually impaired students in higher education. By seamlessly integrating with Moodle-based Learning Management Systems (LMS).',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 120),
                    ElevatedButton(
                      onPressed: () async {
                        await tts.speak(
                            'Opening Portal'); // Speak message before navigating
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WebViewPage(isDarkMode: isDarkMode)),
                        );
                      },
                      child: const Text('Open Portal'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
