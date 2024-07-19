import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    const initialWebpage = 'https://klms.kyu.ac.ug/login/index.php';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kyambogo E-Learning Platform'),
      ),
      body: const WebView(
        initialUrl: initialWebpage,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
