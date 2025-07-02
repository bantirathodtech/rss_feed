import 'package:flutter/material.dart';

import '../utils/url_utils.dart'; // Relative import for utilities
import 'feed_detail_screen.dart'; // Relative import for screens

/// A screen that displays a list of RSS feed URLs.
///
/// Tapping on a URL in the list navigates the user to the
/// [FeedDetailScreen] to view the articles from that specific feed.
class FeedListScreen extends StatefulWidget {
  /// A list of RSS feed URLs to display.
  ///
  /// This parameter is required and should contain valid RSS feed URLs.
  final List<String> feedUrls;

  /// Creates a [FeedListScreen].
  ///
  /// Requires a list of [feedUrls] to display.
  const FeedListScreen({super.key, required this.feedUrls});

  @override
  State<FeedListScreen> createState() => _FeedListScreenState();
}

class _FeedListScreenState extends State<FeedListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RSS Feeds - Suvidha'),
        centerTitle: true,
      ),
      body: widget.feedUrls.isEmpty
          ? const Center(
              child: Text(
                'No RSS feed URLs provided.\nAdd URLs to FeedListScreen.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: widget.feedUrls.length, // Use the provided feedUrls
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 1.0, // Added a little elevation
                  child: ListTile(
                    title: Text(
                      // Get the display name for the feed URL
                      UrlUtils.getFeedName(widget.feedUrls[index]),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        widget.feedUrls[index]), // Show the URL as subtitle
                    onTap: () {
                      // Navigate to the detail screen, passing the selected feed URL
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedDetailScreen(
                              feedUrl: widget
                                  .feedUrls[index]), // Pass the selected URL
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
