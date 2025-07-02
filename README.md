# rss_feed

A comprehensive Flutter package for easily integrating and displaying RSS feeds within your applications. This package provides ready-to-use screens and widgets for listing feeds, viewing articles, and even opening full articles in an in-app WebView.

## Features

* **Fetch and Parse RSS Feeds**: Easily fetch and parse RSS feeds from various sources.
* **Configurable Feed List Screen**: A pre-built screen (`FeedListScreen`) that accepts a `List<String>` of RSS feed URLs, allowing developers to easily manage their feed sources.
* **Feed Detail Screen**: Displays a list of articles from a selected RSS feed.
* **Customizable News Card**: A reusable widget (`CustomNewsCard`) to display individual news items with title, description, date, and optional image.
* **Article Detail Screen**: Shows a detailed view of an article, cleaning HTML tags from content.
* **In-App WebView**: Opens the full article URL in a `webview_flutter` powered screen, keeping users within your app.
* **Utility Functions**: Helper functions for date formatting, HTML tag removal, and smart feed name detection.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  rss_feed: ^0.1.0 # Use the latest version from pub.dev
Then, run flutter pub get in your terminal.

Usage
The rss_feed package provides a set of screens and utilities that you can directly integrate into your Flutter application.

Basic Setup with Configurable URLs
To display a list of RSS feeds, simply pass your desired feed URLs to the FeedListScreen:

Dart

import 'package:flutter/material.dart';
import 'package:rss_feed/rss_feed.dart'; // Import your package

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Define the RSS feed URLs you want to display
  final List<String> myRssFeedUrls = const [
    '[https://www.bbc.com/news/world/rss.xml](https://www.bbc.com/news/world/rss.xml)',
    '[https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml](https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml)',
    '[https://feeds.bbci.co.uk/news/technology/rss.xml](https://feeds.bbci.co.uk/news/technology/rss.xml)',
    '[https://www.aajtak.in/rss](https://www.aajtak.in/rss)',
    '[https://www.ndtv.com/rss](https://www.ndtv.com/rss)',
    '[https://tv9telugu.com/feed](https://tv9telugu.com/feed)',
    '[https://marathi.abplive.com/rss](https://marathi.abplive.com/rss)',
    '[https://marathi.tv9marathi.com/feed](https://marathi.tv9marathi.com/feed)',
    // Add or remove any RSS feed URLs here
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My RSS Reader App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // Pass the list of URLs to the FeedListScreen
      home: FeedListScreen(feedUrls: myRssFeedUrls),
    );
  }
}
Accessing Individual Components
You can also use individual components like CustomNewsCard or WebViewScreen independently if you want to build your own custom UI flow. The utility functions (FeedParser, StringUtils, UrlUtils) are also publicly accessible.

Dart

import 'package:flutter/material.dart';
import 'package:rss_feed/rss_feed.dart'; // Import your package
import 'package:rss_dart/dart_rss.dart'; // Needed for RssItem if you're parsing manually

class MyCustomArticleDisplay extends StatelessWidget {
  final RssItem articleItem;
  final String articleLink;
  final String? articleImageUrl;

  const MyCustomArticleDisplay({
    super.key,
    required this.articleItem,
    required this.articleLink,
    this.articleImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Custom Article')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomNewsCard(
              title: articleItem.title ?? 'Untitled',
              description: articleItem.description ?? 'No description',
              date: articleItem.pubDate ?? 'Unknown date',
              imageUrl: articleImageUrl,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                      url: articleLink,
                      title: articleItem.title ?? 'Article',
                    ),
                  ),
                );
              },
            ),
            // You can add more custom content here
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                StringUtils.cleanContent(articleItem.content?.value ?? articleItem.description ?? ''),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Contributing
Contributions are welcome! If you find a bug or want to add a new feature, please open an issue or submit a pull request on the GitHub repository.

License
This package is licensed under the MIT License. See the LICENSE file for more details.