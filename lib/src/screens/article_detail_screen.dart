import 'package:flutter/material.dart';

import '../utils/string_utils.dart'; // Relative import for utilities
import 'web_view_screen.dart'; // Relative import for WebViewScreen

class ArticleDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final String url;
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebViewScreen(url: url, title: title),
                    ),
                  );
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
