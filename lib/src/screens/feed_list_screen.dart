import 'package:flutter/material.dart';

import '../utils/config.dart';
import '../utils/url_utils.dart';
import 'feed_detail_screen.dart';

/// A screen that displays a list of RSS feed URLs with optional custom names.
///
/// Tapping a feed navigates to the [FeedDetailScreen] to view its articles.
/// Supports customization via [RSSConfig].
class FeedListScreen extends StatefulWidget {
  /// List of RSS feed URLs to display.
  final List<String> feedUrls;

  /// Configuration for customizing the feed UI and behavior.
  final RSSConfig config;

  const FeedListScreen({
    super.key,
    required this.feedUrls,
    this.config = const RSSConfig(),
  });

  @override
  State<FeedListScreen> createState() => _FeedListScreenState();
}

class _FeedListScreenState extends State<FeedListScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = widget.config.theme ?? Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('RSS Feeds'),
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
                itemCount: widget.feedUrls.length,
                itemBuilder: (context, index) {
                  final url = widget.feedUrls[index];
                  final name = widget.config.feedNames?[url] ??
                      UrlUtils.getFeedName(url);
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 1.0,
                    child: ListTile(
                      title: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(url),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedDetailScreen(
                              feedUrl: url,
                              config: widget.config,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
