import 'package:flutter/material.dart';
import 'package:rss_feed/rss_feed.dart'; // Import your package

void main() {
  runApp(const RSSReaderExampleApp());
}

class RSSReaderExampleApp extends StatelessWidget {
  const RSSReaderExampleApp({super.key});

  // These are the URLs that developers using your package will provide.
  // In a real app, these could come from a config file, API, etc.
  final List<String> developerProvidedFeedUrls = const [
    'https://www.bbc.com/news/world/rss.xml',
    'https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml',
    'https://feeds.bbci.co.uk/news/technology/rss.xml',
    'https://www.aajtak.in/rss',
    'https://www.ndtv.com/rss',
    'https://tv9telugu.com/feed',
    'https://marathi.abplive.com/rss',
    'https://marathi.tv9marathi.com/feed',
    // Add more URLs here as a developer using the package would!
    'https://www.thehindu.com/feeder/default.rss', // Example of adding another URL
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSS Feed Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Pass the list of URLs to the FeedListScreen
      home: FeedListScreen(feedUrls: developerProvidedFeedUrls),
    );
  }
}
