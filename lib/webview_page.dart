import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'text_to_speech.dart';

class WebViewPage extends StatefulWidget {
  final bool isDarkMode;

  WebViewPage({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  final TextToSpeech tts = TextToSpeech();
  bool isSpeaking = false;

  void toggleVoice() async {
    if (isSpeaking) {
      await tts.stop();
    } else {
      String pageContent = await _controller
          .runJavascriptReturningResult("document.body.innerText");
      await tts.speak(pageContent);
    }
    setState(() {
      isSpeaking = !isSpeaking;
    });
  }

  @override
  Widget build(BuildContext context) {
    const initialWebpage = 'https://klms.kyu.ac.ug/login/index.php';

    return Scaffold(
        appBar: AppBar(
          title: const Text('Kyambogo E-Learning Platform'),
        ),
        body: Stack(children: [
          WebView(
            initialUrl: initialWebpage,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
            },
            onPageFinished: (String url) async {
              if (widget.isDarkMode) {
                _setDarkMode();
              }
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () async {
                String pageContent = await _controller
                    .runJavascriptReturningResult("document.body.innerText");
                await tts.speak(pageContent);
              },
              child: const Icon(Icons.volume_up),
            ),
          ),
        ]));
  }

  void _setDarkMode() {
    const darkModeCss = """
      document.querySelectorAll('div').forEach((element) => {
        element.style.backgroundColor = '#121212';
        element.style.color = '#ffffff';
        element.style.fontSize = '1.05em';
      });
    """;

    _controller.runJavascript(darkModeCss);
  }
}
