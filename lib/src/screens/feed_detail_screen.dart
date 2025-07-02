import 'package:flutter/material.dart';
import 'package:rss_dart/domain/rss_feed.dart'; // Corrected import for RssFeed from rss_dart

import '../../rss_feed.dart'; // Corrected relative import for FeedParser, UrlUtils, CustomNewsCard, ArticleDetailScreen

/// A screen that displays a list of articles from a single RSS feed.
///
/// It takes a [feedUrl] and displays articles fetched from that URL in a scrollable list.
/// Each article is presented as a [CustomNewsCard] which, when tapped, navigates
/// to the [ArticleDetailScreen] or opens the full article in a [WebViewScreen].
class FeedDetailScreen extends StatefulWidget {
  /// The URL of the RSS feed to display.
  final String feedUrl;

  /// Creates a [FeedDetailScreen].
  ///
  /// Requires the [feedUrl] to fetch and display articles from.
  const FeedDetailScreen({super.key, required this.feedUrl});

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  late Future<RssFeed> futureFeed;

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch the RSS feed
    futureFeed = FeedParser.fetchFeed(widget.feedUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Display the feed name using a utility function
        title: Text(UrlUtils.getFeedName(widget.feedUrl)),
        centerTitle: true, // Center the title for better UI
      ),
      body: FutureBuilder<RssFeed>(
        future: futureFeed,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final feed = snapshot.data!;
            // Check if the feed contains any articles
            if (feed.items == null || feed.items!.isEmpty) {
              return const Center(
                  child: Text('No articles found in this feed.'));
            }
            return ListView.builder(
              itemCount: feed.items.length,
              itemBuilder: (context, index) {
                final item = feed.items[index];
                return CustomNewsCard(
                  title: item.title ?? 'No title',
                  description: item.description ?? 'No description',
                  date: item.pubDate ?? 'No date',
                  // Extract image URL using a utility function
                  imageUrl: FeedParser.getImageUrl(item),
                  onTap: () {
                    // Navigate to article detail if a link is available
                    if (item.link != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailScreen(
                            title: item.title ?? 'No title',
                            content: item.description ?? 'No content',
                            url: item.link!,
                            imageUrl: FeedParser.getImageUrl(item),
                          ),
                        ),
                      );
                    } else {
                      // Show a message if no link is found
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('No link available for this article.')),
                      );
                    }
                  },
                );
              },
            );
          }
          return const Center(
              child: Text(
                  'Unexpected state.')); // Fallback for unexpected FutureBuilder state
        },
      ),
    );
  }
}
