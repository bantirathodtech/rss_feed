import 'package:flutter/material.dart';
import 'package:rss_feed/rss_feed.dart';

/// Example app demonstrating how to use the RSS Feed package.
void main() {
  runApp(const RSSReaderExampleApp());
}

/// The main application widget for the RSS Feed example.
class RSSReaderExampleApp extends StatelessWidget {
  const RSSReaderExampleApp({super.key});

  /// List of RSS feed URLs provided by the developer.
  ///
  /// These URLs are passed to [FeedListScreen] to display feeds.
  /// In a real app, these could come from a config file or API.
  static const List<String> developerProvidedFeedUrls = [
    'https://www.bbc.com/news/world/rss.xml',
    'https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml',
    'https://feeds.bbci.co.uk/news/technology/rss.xml',
    'https://www.aajtak.in/rss',
    'https://www.ndtv.com/rss',
    'https://tv9telugu.com/feed',
    'https://marathi.abplive.com/rss',
    'https://marathi.tv9marathi.com/feed',
    'https://www.thehindu.com/feeder/default.rss',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSS Feed Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: FeedListScreen(
        feedUrls: developerProvidedFeedUrls,
        config: RSSConfig(
          defaultImageUrl: 'https://via.placeholder.com/150',
          feedNames: const {
            'https://www.bbc.com/news/world/rss.xml': 'BBC Global',
            'https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml':
                'NYT Home',
            'https://feeds.bbci.co.uk/news/technology/rss.xml': 'BBC Tech',
            'https://www.thehindu.com/feeder/default.rss': 'The Hindu News',
          },
          theme: ThemeData(primarySwatch: Colors.blue),
        ),
      ),
    );
  }
}
