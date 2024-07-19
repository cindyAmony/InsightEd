import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  FlutterTts flutterTts = FlutterTts();
  String? selectedVoice; // Track selected voice

  // Define the target voices and their genders
  List<Map<String, String>> targetVoices = [
    {'locale': 'en-us-x-tpf-local', 'gender': 'female'},
    {'locale': 'en-gb-x-gbg-local', 'gender': 'male'},
    {'locale': 'en-us-x-tpc-local', 'gender': 'female'},
    {'locale': 'en-gb-x-gbb-local', 'gender': 'male'},
    {'locale': 'en-gb-x-gbc-local', 'gender': 'female'},
    {'locale': 'en-us-x-iol-local', 'gender': 'female'},
    {'locale': 'en-us-x-iom-local', 'gender': 'male'},
    {'locale': 'en-gb-x-gbc-network', 'gender': 'female'},
  ];

  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  String? language;
  String? engine;

  Future<void> initTts() async {
    flutterTts = FlutterTts();

    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.awaitSpeakCompletion(true);

    flutterTts.setStartHandler(() {
      print("Playing");
    });

    flutterTts.setCompletionHandler(() {
      print("Complete");
    });

    flutterTts.setCancelHandler(() {
      print("Cancel");
    });

    flutterTts.setErrorHandler((message) {
      print("Error Handler: $message");
    });

    // Initialize the default voice when the TTS is initialized
    await setDefaultVoice();
  }

  Future<void> setDefaultVoice() async {
    // Set the default voice to en-gb-x-gbg-local if none selected
    selectedVoice = 'en-gb-x-gbg-local';
    await setVoice(selectedVoice!);
  }

  Future<List<Map<String, String>>> getAvailableVoices() async {
    List<Map<String, String>> availableVoices = [];

    for (var targetVoice in targetVoices) {
      availableVoices.add({
        'locale': targetVoice['locale']!,
        'gender': targetVoice['gender']!,
      });
    }

    return availableVoices;
  }

  Future<void> setVoice(String voiceLocale) async {
    await flutterTts.setVoice({"name": voiceLocale, "locale": voiceLocale});
    selectedVoice = voiceLocale;
  }

  Future<void> speak(String text) async {
    // Set a default voice if selectedVoice is null
    if (selectedVoice == null) {
      await flutterTts.setVoice({
        'name': 'Default Voice',
        'locale': 'en-gb-x-gbg-local', // Default to this voice
      });
    } else {
      // Use selected voice if available
      List<dynamic> voices = await flutterTts.getVoices;
      for (var voice in voices) {
        if (voice['name'].toString() == selectedVoice) {
          await flutterTts.setVoice({
            'name': voice['name'].toString(),
            'locale': voice['locale'].toString(),
          });
          break;
        }
      }
    }

    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(text);
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  Future<void> pause() async {
    await flutterTts.pause();
  }

  Future<void> setLanguage(String lang) async {
    language = lang;
    await flutterTts.setLanguage(language!);
  }

  Future<void> setVolume(double vol) async {
    volume = vol;
    await flutterTts.setVolume(volume);
  }

  Future<void> setPitch(double pit) async {
    pitch = pit;
    await flutterTts.setPitch(pitch);
  }

  Future<void> setRate(double rate) async {
    this.rate = rate;
    await flutterTts.setSpeechRate(rate);
  }
}
