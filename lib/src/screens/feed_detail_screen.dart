import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../models/rss_feed.dart';
import '../utils/config.dart';
import '../utils/feed_parser.dart';
import '../utils/string_utils.dart';
import 'article_detail_screen.dart';

/// A screen that displays articles from a single RSS feed in a modern, magazine-style layout.
///
/// Supports list/grid views, hero images, search, and animations, customizable via [RSSConfig].
class FeedDetailScreen extends StatefulWidget {
  /// The URL of the RSS feed to display.
  final String feedUrl;

  /// Configuration for customizing the UI and behavior.
  final RSSConfig config;

  const FeedDetailScreen({
    super.key,
    required this.feedUrl,
    this.config = const RSSConfig(),
  });

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen>
    with SingleTickerProviderStateMixin {
  late Future<RssFeed> _feedFuture;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late TextEditingController _searchController;
  String _searchQuery = '';
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _fetchFeed();
    _searchController = TextEditingController();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Fetches the RSS feed data.
  void _fetchFeed() {
    _feedFuture = FeedParser.fetchFeed(widget.feedUrl);
  }

  /// Refreshes the feed data.
  Future<void> _refreshFeed() async {
    setState(() {
      _fetchFeed();
    });
    await _feedFuture;
  }

  /// Filters articles based on search query.
  List<RssItem> _filterArticles(List<RssItem> items) {
    if (_searchQuery.isEmpty) return items;
    return items.where((item) {
      final title = item.title?.toLowerCase() ?? '';
      final description = item.description?.toLowerCase() ?? '';
      return title.contains(_searchQuery.toLowerCase()) ||
          description.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.config.theme ?? Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: FutureBuilder<RssFeed>(
            future: _feedFuture,
            builder: (context, snapshot) {
              return Text(
                snapshot.hasData
                    ? snapshot.data!.title ?? 'Articles'
                    : 'Loading...',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              );
            },
          ),
          centerTitle: true,
          elevation: 4.0,
          backgroundColor: theme.primaryColor,
          actions: [
            IconButton(
              icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
              tooltip: 'Toggle View',
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                  _controller.reset();
                  _controller.forward();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Articles',
              onPressed: _refreshFeed,
            ),
          ],
        ),
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search articles...',
                  prefixIcon: Icon(Icons.search, color: theme.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerLow,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<RssFeed>(
                future: _feedFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingState(context);
                  }
                  if (snapshot.hasError) {
                    return _buildErrorState(context, snapshot.error.toString());
                  }
                  final items = _filterArticles(snapshot.data!.items);
                  if (items.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return RefreshIndicator(
                    onRefresh: _refreshFeed,
                    color: theme.primaryColor,
                    child: _isGridView
                        ? _buildGridView(context, items)
                        : _buildListView(context, items),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a list view for articles.
  Widget _buildListView(BuildContext context, List<RssItem> items) {
    final theme = widget.config.theme ?? Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: _buildArticleCard(context, item, index, isGrid: false),
        );
      },
    );
  }

  /// Builds a grid view for articles.
  Widget _buildGridView(BuildContext context, List<RssItem> items) {
    final theme = widget.config.theme ?? Theme.of(context);
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: _buildArticleCard(context, item, index, isGrid: true),
        );
      },
    );
  }

  /// Builds a card for each article with a hero image and text overlay.
  Widget _buildArticleCard(BuildContext context, RssItem item, int index,
      {required bool isGrid}) {
    final theme = widget.config.theme ?? Theme.of(context);
    final imageUrl = FeedParser.getImageUrl(item,
        fallbackImageUrl: widget.config.defaultImageUrl);

    return Hero(
      tag: 'article-${item.link ?? item.title ?? index.toString()}',
      child: Card(
        elevation: 8.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailScreen(
                  title: item.title ?? 'Untitled',
                  content: item.description ?? 'No content',
                  url: item.link ?? '',
                  imageUrl: imageUrl,
                ),
              ),
            );
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Hero image
              if (imageUrl != null &&
                  Uri.tryParse(imageUrl)?.hasAuthority == true)
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: isGrid ? null : 240.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: isGrid ? null : 240.0,
                      color: Colors.grey[300],
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: isGrid ? null : 240.0,
                    color: theme.colorScheme.surfaceContainer,
                    child: Icon(
                      Icons.article,
                      size: 80.0,
                      color: theme.primaryColor,
                      semanticLabel: 'Article Icon',
                    ),
                  ),
                )
              else
                Container(
                  height: isGrid ? null : 240.0,
                  color: theme.colorScheme.surfaceContainer,
                  child: Icon(
                    Icons.article,
                    size: 80.0,
                    color: theme.primaryColor,
                    semanticLabel: 'Article Icon',
                  ),
                ),
              // Gradient overlay
              Container(
                height: isGrid ? null : 240.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      theme.colorScheme.surface.withOpacity(0.85),
                    ],
                  ),
                ),
              ),
              // Article details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isGrid &&
                        (imageUrl == null ||
                            Uri.tryParse(imageUrl)?.hasAuthority != true))
                      const SizedBox(height: 8.0),
                    Text(
                      item.title ?? 'Untitled',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isGrid ? 15.0 : 18.0,
                        color: imageUrl != null &&
                                Uri.tryParse(imageUrl)?.hasAuthority == true
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onBackground,
                      ),
                      maxLines: isGrid ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isGrid) const SizedBox(height: 8.0),
                    if (!isGrid)
                      Text(
                        StringUtils.cleanContent(
                            item.description ?? 'No description'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: imageUrl != null &&
                                  Uri.tryParse(imageUrl)?.hasAuthority == true
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onBackground.withOpacity(0.7),
                          fontSize: 13.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 6.0),
                    Text(
                      item.pubDate ?? 'Unknown date',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: imageUrl != null &&
                                Uri.tryParse(imageUrl)?.hasAuthority == true
                            ? theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.7)
                            : theme.colorScheme.onBackground.withOpacity(0.7),
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a loading state with shimmer placeholders.
  Widget _buildLoadingState(BuildContext context) {
    final theme = widget.config.theme ?? Theme.of(context);
    return _isGridView
        ? GridView.builder(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Container(
                    color: Colors.grey[300],
                  ),
                ),
              );
            },
          )
        : ListView.builder(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 240.0,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 12.0),
                        Container(
                          width: double.infinity,
                          height: 18.0,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          width: double.infinity,
                          height: 13.0,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 6.0),
                        Container(
                          width: 100.0,
                          height: 11.0,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  /// Builds an error state with a Lottie animation and retry button.
  Widget _buildErrorState(BuildContext context, String error) {
    final theme = widget.config.theme ?? Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
            'https://assets.lottiefiles.com/packages/lf20_jcikweox.json',
            width: 120.0,
            height: 120.0,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.error_outline,
              size: 64.0,
              color: theme.colorScheme.error,
              semanticLabel: 'Error Icon',
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Failed to load articles',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            error,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton.icon(
            onPressed: _refreshFeed,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds an empty state with a Lottie animation and call-to-action.
  Widget _buildEmptyState(BuildContext context) {
    final theme = widget.config.theme ?? Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
            'https://assets.lottiefiles.com/packages/lf20_y6gtrvlj.json',
            width: 120.0,
            height: 120.0,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.article,
              size: 64.0,
              color: theme.primaryColor.withOpacity(0.6),
              semanticLabel: 'No Articles Icon',
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'No articles found',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            'The feed may be empty or your search returned no results.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton.icon(
            onPressed: _refreshFeed,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
