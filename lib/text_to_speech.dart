import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  FlutterTts flutterTts = FlutterTts();

  Future<void> initTts() async {
    flutterTts = FlutterTts();

    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.3);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    flutterTts.setProgressHandler((text, start, end, word) {
      print('Progress Handler');
    });

    flutterTts.setCompletionHandler(() {
      print('Complete Handler');
    });

    flutterTts.setErrorHandler((message) {
      print('Error Handler: $message');
    });
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }
}
