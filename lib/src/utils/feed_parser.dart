import 'package:http/http.dart' as http;
import 'package:rss_dart/dart_rss.dart'; // Core library for RSS data models

/// A utility class for fetching and parsing RSS feed data.
///
/// Provides methods to retrieve RSS feeds from a URL and extract specific
/// information like image URLs from RSS items.
class FeedParser {
  /// Fetches an RSS feed from the given [url].
  ///
  /// Performs an HTTP GET request to the [url] and parses the response body
  /// into an [RssFeed] object.
  /// Throws an [Exception] if the HTTP request fails (status code is not 200).
  static Future<RssFeed> fetchFeed(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return RssFeed.parse(response.body);
    } else {
      throw Exception(
          'Failed to load RSS feed from $url: ${response.statusCode}');
    }
  }

  /// Extracts an image URL from an [RssItem].
  ///
  /// It attempts to find an image URL from `media:content`, then `enclosure`,
  /// and finally tries to parse an `<img>` tag from the item's `description`.
  ///
  /// Returns the found image URL as a [String], or `null` if no image URL is found.
  static String? getImageUrl(RssItem item) {
    // Try to extract image from media:content
    if (item.media?.contents.isNotEmpty ?? false) {
      return item.media?.contents.first.url;
    }
    // Try to extract image from enclosure
    if (item.enclosure?.url != null) {
      return item.enclosure?.url;
    }
    // You might also want to try parsing images from the description if present
    // Example: Use regex to find img src tags
    final RegExp imgRegExp = RegExp(r'<img[^>]+src="([^">]+)"');
    final match = imgRegExp.firstMatch(item.description ?? '');
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }
}
