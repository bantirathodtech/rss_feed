/// A comprehensive Flutter package for easily integrating and displaying RSS feeds within your applications.
///
/// This library provides pre-built screens, widgets, and utility functions
/// to fetch, parse, display, and interact with RSS feed content.
///
/// To get started, consider using [FeedListScreen] to display a list of RSS feeds
/// from provided URLs, or [FeedDetailScreen] to show articles from a single feed.
/// For viewing individual articles, [ArticleDetailScreen] and [WebViewScreen] are provided.
library rss_feed;

export 'src/screens/article_detail_screen.dart';
export 'src/screens/feed_detail_screen.dart';
// Export screens to make them easily accessible when importing 'package:rss_feed/rss_feed.dart'
export 'src/screens/feed_list_screen.dart';
export 'src/screens/web_view_screen.dart';
// Export utilities
export 'src/utils/feed_parser.dart';
export 'src/utils/string_utils.dart';
export 'src/utils/url_utils.dart';
// Export widgets
export 'src/widgets/custom_news_card.dart';
