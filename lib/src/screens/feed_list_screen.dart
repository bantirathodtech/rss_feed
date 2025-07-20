import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/config.dart';
import '../utils/url_utils.dart';
import 'feed_detail_screen.dart';

/// A screen that displays a list of RSS feed URLs with custom names and icons.
///
/// Tapping a feed navigates to the [FeedDetailScreen] to view its articles.
/// Supports advanced customization via [RSSConfig], including theme, icons, and refresh functionality.
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

class _FeedListScreenState extends State<FeedListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
// Initialize animation controller for fade-in effect
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Refreshes the feed list (placeholder for future functionality).
  Future<void> _refreshFeeds() async {
// Simulate a refresh delay
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.config.theme ?? Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('RSS Feeds'),
          centerTitle: true,
          elevation: 2.0,
          backgroundColor: theme.primaryColor,
          titleTextStyle: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Feeds',
              onPressed: _refreshFeeds,
            ),
          ],
        ),
        body: widget.feedUrls.isEmpty
            ? _buildEmptyState(context)
            : RefreshIndicator(
                onRefresh: _refreshFeeds,
                color: theme.primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  itemCount: widget.feedUrls.length,
                  itemBuilder: (context, index) {
                    final url = widget.feedUrls[index];
                    final name = widget.config.feedNames?[url] ??
                        UrlUtils.getFeedName(url);
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildFeedCard(context, url, name),
                    );
                  },
                ),
              ),
      ),
    );
  }

  /// Builds a card for each RSS feed with an icon, name, and URL.
  Widget _buildFeedCard(BuildContext context, String url, String name) {
    final theme = widget.config.theme ?? Theme.of(context);
    final faviconUrl = widget.config.defaultImageUrl != null
        ? '${Uri.parse(url).host}/favicon.ico'
        : widget.config.defaultImageUrl;

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
// Favicon or placeholder image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: faviconUrl ?? 'https://via.placeholder.com/48',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 48,
                      height: 48,
                      color: Colors.grey[300],
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.rss_feed,
                    size: 48,
                    color: theme.primaryColor,
                    semanticLabel: 'RSS Feed Icon',
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
// Feed name and URL
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      url,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.0,
                color: theme.primaryColor,
                semanticLabel: 'Navigate to Feed',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds an empty state widget with a call-to-action.
  Widget _buildEmptyState(BuildContext context) {
    final theme = widget.config.theme ?? Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rss_feed,
            size: 64.0,
            color: theme.primaryColor.withOpacity(0.6),
            semanticLabel: 'No Feeds Icon',
          ),
          const SizedBox(height: 16.0),
          Text(
            'No RSS feeds available',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            'Add feed URLs to FeedListScreen to get started.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton.icon(
            onPressed: _refreshFeeds,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// import '../utils/config.dart';
// import '../utils/url_utils.dart';
// import 'feed_detail_screen.dart';
//
// /// A screen that displays a list of RSS feed URLs with optional custom names.
// ///
// /// Tapping a feed navigates to the [FeedDetailScreen] to view its articles.
// /// Supports customization via [RSSConfig].
// class FeedListScreen extends StatefulWidget {
//   /// List of RSS feed URLs to display.
//   final List<String> feedUrls;
//
//   /// Configuration for customizing the feed UI and behavior.
//   final RSSConfig config;
//
//   const FeedListScreen({
//     super.key,
//     required this.feedUrls,
//     this.config = const RSSConfig(),
//   });
//
//   @override
//   State<FeedListScreen> createState() => _FeedListScreenState();
// }
//
// class _FeedListScreenState extends State<FeedListScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final theme = widget.config.theme ?? Theme.of(context);
//     return Theme(
//       data: theme,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('RSS Feeds'),
//           centerTitle: true,
//         ),
//         body: widget.feedUrls.isEmpty
//             ? const Center(
//                 child: Text(
//                   'No RSS feed URLs provided.\nAdd URLs to FeedListScreen.',
//                   textAlign: TextAlign.center,
//                 ),
//               )
//             : ListView.builder(
//                 itemCount: widget.feedUrls.length,
//                 itemBuilder: (context, index) {
//                   final url = widget.feedUrls[index];
//                   final name = widget.config.feedNames?[url] ??
//                       UrlUtils.getFeedName(url);
//                   return Card(
//                     margin: const EdgeInsets.all(8.0),
//                     elevation: 1.0,
//                     child: ListTile(
//                       title: Text(
//                         name,
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text(url),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => FeedDetailScreen(
//                               feedUrl: url,
//                               config: widget.config,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }
