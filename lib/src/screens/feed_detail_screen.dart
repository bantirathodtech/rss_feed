import 'package:flutter/material.dart';

import '../models/rss_feed.dart';
import '../utils/config.dart';
import '../utils/feed_parser.dart';
import '../utils/url_utils.dart';
import '../widgets/custom_news_card.dart';
import 'article_detail_screen.dart';

/// A screen that displays a list of articles from a single RSS feed.
///
/// Fetches articles from the provided [feedUrl] and displays them as [CustomNewsCard]s.
/// Supports customization via [RSSConfig].
class FeedDetailScreen extends StatefulWidget {
  /// The URL of the RSS feed to display.
  final String feedUrl;

  /// Configuration for customizing the feed UI and behavior.
  final RSSConfig config;

  const FeedDetailScreen({
    super.key,
    required this.feedUrl,
    this.config = const RSSConfig(),
  });

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  late Future<RssFeed> futureFeed;

  @override
  void initState() {
    super.initState();
    futureFeed = FeedParser.fetchFeed(widget.feedUrl);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.config.theme ?? Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(UrlUtils.getFeedName(widget.feedUrl)),
          centerTitle: true,
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
                    imageUrl: FeedParser.getImageUrl(
                      item,
                      fallbackImageUrl: widget.config.defaultImageUrl,
                    ),
                    placeholderImage:
                        const Icon(Icons.article, size: 50, color: Colors.grey),
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
                                item,
                                fallbackImageUrl: widget.config.defaultImageUrl,
                              ),
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
      ),
    );
  }
}
