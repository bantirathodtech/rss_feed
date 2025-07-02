import 'package:flutter/material.dart';
import 'package:rss_dart/dart_rss.dart';

import '../utils/feed_parser.dart'; // Relative import for utilities
import '../utils/url_utils.dart'; // Relative import for utilities
import '../widgets/custom_news_card.dart'; // Relative import for widgets
import 'article_detail_screen.dart'; // Relative import for screens

class FeedDetailScreen extends StatefulWidget {
  final String feedUrl;

  const FeedDetailScreen({super.key, required this.feedUrl});

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  late Future<RssFeed> futureFeed;

  @override
  void initState() {
    super.initState();
    futureFeed =
        FeedParser.fetchFeed(widget.feedUrl); // Using FeedParser utility
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            UrlUtils.getFeedName(widget.feedUrl)), // Using UrlUtils utility
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
            if (feed.items.isEmpty) {
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
                  imageUrl:
                      FeedParser.getImageUrl(item), // Using FeedParser utility
                  onTap: () {
                    if (item.link != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailScreen(
                            title: item.title ?? 'No title',
                            content: item.description ?? 'No content',
                            url: item.link!,
                            imageUrl: FeedParser.getImageUrl(
                                item), // Using FeedParser utility
                          ),
                        ),
                      );
                    } else {
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
          return const Center(child: Text('Unexpected state.'));
        },
      ),
    );
  }
}
