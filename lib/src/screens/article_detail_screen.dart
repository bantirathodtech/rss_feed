import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../utils/string_utils.dart';
import '../utils/url_utils.dart';
import 'web_view_screen.dart';

/// A screen that displays the detailed content of an RSS article.
///
/// Shows the article's title, cleaned content, and optional image.
/// Includes a button to open the full article in a [WebViewScreen] or external browser.
class ArticleDetailScreen extends StatelessWidget {
  /// The title of the article.
  final String title;

  /// The content or description of the article.
  final String content;

  /// The URL to the full article.
  final String url;

  /// Optional URL for the article's image.
  final String? imageUrl;

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
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
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
              StringUtils.cleanContent(content),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (kIsWeb || Platform.isWindows || Platform.isLinux) {
                    UrlUtils.launchExternalUrl(url);
                  } else {
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
