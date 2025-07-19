import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A screen that displays a web page in an in-app WebView.
///
/// Used to show the full version of an RSS article.
class WebViewScreen extends StatelessWidget {
  /// The URL of the web page to display.
  final String url;

  /// The title to display in the AppBar.
  final String title;

  const WebViewScreen({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
