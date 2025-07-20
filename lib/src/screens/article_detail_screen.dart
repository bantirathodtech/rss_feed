import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/string_utils.dart';
import '../utils/url_utils.dart';
import 'web_view_screen.dart';

/// A screen that displays the detailed content of an RSS article in a premium layout.
///
/// Shows a hero image, title, cleaned content, and buttons for reading and sharing.
/// Customizable via [ThemeData] and supports web/mobile navigation.
class ArticleDetailScreen extends StatelessWidget {
  /// The title of the article.
  final String title;

  /// The content or description of the article.
  final String content;

  /// The URL to the full article.
  final String url;

  /// Optional URL for the article's image.
  final String? imageUrl;

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.content,
    required this.url,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver app bar with hero image
          SliverAppBar(
            expandedHeight: 280.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                  fontSize: 18.0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl != null &&
                      Uri.tryParse(imageUrl!)?.hasAuthority == true)
                    CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.grey[300]),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: theme.colorScheme.surfaceContainer,
                        child: Icon(
                          Icons.broken_image,
                          size: 80.0,
                          color: theme.primaryColor,
                          semanticLabel: 'Broken Image',
                        ),
                      ),
                    )
                  else
                    Container(
                      color: theme.colorScheme.surfaceContainer,
                      child: Icon(
                        Icons.article,
                        size: 80.0,
                        color: theme.primaryColor,
                        semanticLabel: 'Article Icon',
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          theme.colorScheme.surface.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: theme.primaryColor,
            elevation: 4.0,
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Share Article',
                onPressed: () {
                  Share.share('Check out this article: $title\n$url');
                },
              ),
            ],
          ),
          // Article content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl == null ||
                      Uri.tryParse(imageUrl!)?.hasAuthority != true)
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                  if (imageUrl == null ||
                      Uri.tryParse(imageUrl!)?.hasAuthority != true)
                    const SizedBox(height: 16.0),
                  Text(
                    StringUtils.cleanContent(content),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 15.0,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (kIsWeb ||
                                Platform.isWindows ||
                                Platform.isLinux) {
                              UrlUtils.launchExternalUrl(url);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                    url: url,
                                    title: title,
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Read Full Article'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Share.share('Check out this article: $title\n$url');
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
