import 'package:http/http.dart' as http;
import 'package:rss_dart/dart_rss.dart';

class FeedParser {
  static Future<RssFeed> fetchFeed(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return RssFeed.parse(response.body);
    } else {
      throw Exception(
          'Failed to load RSS feed from $url: ${response.statusCode}');
    }
  }

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
