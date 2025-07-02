import 'dart:io'
    show
        Platform; // Import Platform for desktop checks (conditional import needed if this causes issues on web)

import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb
import 'package:flutter/material.dart';

import '../utils/string_utils.dart';
import '../utils/url_utils.dart'; // <<<--- for UrlUtils.launchExternalUrl
import 'web_view_screen.dart';

/// A screen that displays the detailed content of an RSS article.
///
/// It shows the article's title, cleaned content, and optionally an image.
/// Provides a button to open the full article in an in-app [WebViewScreen].
class ArticleDetailScreen extends StatelessWidget {
  /// The title of the article.
  final String title;

  /// The main content/description of the article, typically in HTML format.
  /// This content is cleaned of HTML tags before display.
  final String content;

  /// The original URL to the full article on the web.
  /// This URL is used to open the article in the [WebViewScreen].
  final String url;

  /// An optional URL for the article's main image.
  /// If provided, this image will be displayed at the top of the article.
  final String? imageUrl;

  /// Creates an [ArticleDetailScreen].
  ///
  /// Requires [title], [content], and [url].
  /// The [imageUrl] is optional and can be `null` if no image is available.
  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.content,
    required this.url,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey)),
                    ),
                  ),
                ),
              ),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              StringUtils.cleanContent(content), // Using utility function
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Conditionally launch based on platform
                  if (kIsWeb || Platform.isWindows || Platform.isLinux) {
                    // On web, Windows, and Linux, open the URL in the system's default browser
                    // using UrlUtils (which uses url_launcher).
                    UrlUtils.launchExternalUrl(url);
                  } else {
                    // On Android, iOS, and macOS, use the in-app WebViewScreen.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WebViewScreen(url: url, title: title),
                      ),
                    );
                  }
                },
                child: const Text('Read Full Article'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
