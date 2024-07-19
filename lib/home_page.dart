import 'package:flutter/material.dart';
import 'webview_page.dart';
import 'text_to_speech.dart';
import 'speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextToSpeech tts = TextToSpeech();
  String? selectedVoice;

  final SpeechToTextService _speechService = SpeechToTextService();
  String _spokenText = '';

  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    loadVoices();
    _speechService.initialize();
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

  void _onSpeechResult(String result) {
    setState(() {
      _spokenText = result;
    });

    if (_spokenText.trim().toLowerCase() == 'open') {
      _openPortal();
    }
  }

  void _openPortal() async {
    await tts.speak('Opening Portal');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WebViewPage(isDarkMode: isDarkMode)),
    );
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

    if (voiceName != null) {
      tts.setVoice(voiceName); // Set the selected voice
    } else {
      tts.setVoice("en-gb-x-gbg-local"); // Set the Default Voice
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 10),
                  child: DropdownButton<String>(
                    value: selectedVoice,
                    onChanged: onVoiceSelected,
                    items: tts.targetVoices.map((voice) {
                      return DropdownMenuItem<String>(
                        value: voice['locale'],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'Voice ${tts.targetVoices.indexOf(voice) + 1}'), // Display Voice1, Voice2, etc.
                            Text(voice['gender'] == 'female' ? 'F' : 'M'),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await tts.speak('Hey there, its a new Day!');
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
                    Image.asset('assets/insightEd.png', height: 100),
                    const SizedBox(height: 20),
                    const Text(
                      'InsightEd is an innovative mobile application designed to revolutionize the learning experience for visually impaired students in higher education. By seamlessly integrating with Moodle-based Learning Management Systems (LMS).',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: () async {
                        await tts.speak('Opening Portal');
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
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Spoken Text: $_spokenText',
                        overflow: TextOverflow
                            .ellipsis, // Optional: To handle overflow
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _speechService.isListening
                      ? _speechService.stopListening
                      : () => _speechService.startListening(_onSpeechResult),
                  child: Text(_speechService.isListening
                      ? 'Stop Listening'
                      : 'Start Listening'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
