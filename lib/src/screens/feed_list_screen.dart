import 'package:flutter/material.dart';

import '../utils/url_utils.dart'; // Relative import for utilities
import 'feed_detail_screen.dart'; // Relative import for screens

class FeedListScreen extends StatefulWidget {
  final List<String> feedUrls; // Now a required parameter

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
                  elevation: 1.0,
                  child: ListTile(
                    title: Text(
                      UrlUtils.getFeedName(
                          widget.feedUrls[index]), // Using UrlUtils utility
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(widget.feedUrls[index]),
                    onTap: () {
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
