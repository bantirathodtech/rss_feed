import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; // From webview_flutter package

/// A screen that displays a web page using a WebView.
///
/// This is typically used to show the full version of an RSS article within the app.
class WebViewScreen extends StatelessWidget {
  /// The URL of the web page to load and display.
  final String url;

  /// The title to display in the AppBar of the WebView screen.
  final String title;

  /// Creates a [WebViewScreen].
  ///
  /// Requires the [url] to display and a [title] for the AppBar.
  const WebViewScreen({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url)), // Load the specified URL
      ),
    );
  }
}
