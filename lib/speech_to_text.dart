import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';

  Future<void> initialize() async {
    await _speech.initialize();
  }

  void startListening(Function(String) onResult) async {
    if (!_isListening) {
      _isListening = true;
      _speech.listen(
        onResult: (result) {
          _text = result.recognizedWords;
          onResult(_text);
        },
      );
    }
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
    }
  }

  bool get isListening => _isListening;
}
