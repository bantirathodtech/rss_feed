# RSS Feed

A comprehensive Flutter package for displaying and interacting with RSS feeds, featuring customizable UI, robust image handling, and in-app WebView for full articles.

[![Pub Version](https://img.shields.io/pub/v/rss_feed)](https://pub.dev/packages/rss_feed)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Features

- **Fetch and Parse RSS Feeds**: Seamlessly fetch and parse RSS feeds using the `xml` package.
- **Configurable Feed List**: Use `FeedListScreen` to display a list of RSS feed URLs, customizable via `RSSConfig`.
- **Article List View**: Display articles from a selected feed with `FeedDetailScreen`.
- **Customizable News Card**: `CustomNewsCard` widget for stylish article previews with title, description, date, and image.
- **Article Detail View**: `ArticleDetailScreen` for detailed article content, with HTML tag removal.
- **In-App WebView**: Open full articles in `WebViewScreen` (mobile) or external browser (web/desktop).
- **Robust Image Handling**: Extract images from `media:content`, `enclosure`, or `img` tags, with `cached_network_image` for efficient loading.
- **Customization**: Use `RSSConfig` to set custom themes, default images, and feed names.
- **Cross-Platform**: Supports Android, iOS, web, Windows, Linux, and macOS.
- **Developer-Friendly**: Modular design with utility classes (`FeedParser`, `StringUtils`, `UrlUtils`) and detailed documentation.

## Installation

Add to your `pubspec.yaml`:
dependencies:
  rss_feed: ^1.0.0

Run:
flutter pub get

Usage
Basic Setup with Configurable URLs
Display a list of RSS feeds using FeedListScreen with customizable RSSConfig:
import 'package:flutter/material.dart';
import 'package:rss_feed/rss_feed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const List<String> feedUrls = [
    'https://www.bbc.com/news/world/rss.xml',
    'https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml',
    'https://feeds.bbci.co.uk/news/technology/rss.xml',
    'https://www.thehindu.com/feeder/default.rss',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSS Feed Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: FeedListScreen(
        feedUrls: feedUrls,
        config: const RSSConfig(
          defaultImageUrl: 'https://via.placeholder.com/150',
          feedNames: {
            'https://www.bbc.com/news/world/rss.xml': 'BBC Global',
            'https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml': 'NYT Home',
          },
          theme: ThemeData(primarySwatch: Colors.blue),
        ),
      ),
    );
  }
}

Using Individual Components
Use CustomNewsCard or other components for custom UI flows:
import 'package:flutter/material.dart';
import 'package:rss_feed/rss_feed.dart';

class CustomArticleDisplay extends StatelessWidget {
  final RssItem item;

  const CustomArticleDisplay({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title ?? 'Article')),
      body: CustomNewsCard(
        title: item.title ?? 'Untitled',
        description: item.description ?? 'No description',
        date: item.pubDate ?? 'Unknown date',
        imageUrl: FeedParser.getImageUrl(item, fallbackImageUrl: 'https://via.placeholder.com/150'),
        onTap: () {
          if (item.link != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailScreen(
                  title: item.title ?? 'Untitled',
                  content: item.description ?? 'No content',
                  url: item.link!,
                  imageUrl: FeedParser.getImageUrl(item),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

Screenshots

Contributing
Contributions are welcome! Please open an issue or submit a pull request on the GitHub repository.
License
This package is licensed under the MIT License.