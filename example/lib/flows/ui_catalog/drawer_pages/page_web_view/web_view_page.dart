import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  WebViewPage({super.key});

  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          const CircularProgressIndicator();
        },
      ),
    )
    ..loadRequest(Uri.parse('https://www.google.com'));

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
