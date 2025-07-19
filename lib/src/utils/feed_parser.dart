import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../models/rss_feed.dart';

/// A utility class for fetching and parsing RSS feed data from URLs.
///
/// Provides methods to retrieve RSS feeds and extract information like image URLs
/// from RSS items, with support for media content, enclosures, and description parsing.
class FeedParser {
  /// Fetches an RSS feed from the specified [url].
  ///
  /// Performs an HTTP GET request and parses the XML response into an [RssFeed].
  /// Throws an [Exception] if the request fails or the XML is invalid.
  static Future<RssFeed> fetchFeed(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load RSS feed from $url: ${response.statusCode}');
    }

    try {
      final document = XmlDocument.parse(response.body);
      return _parseRssFeed(document);
    } catch (e) {
      throw Exception('Failed to parse RSS feed: $e');
    }
  }

  /// Parses an XML document into an [RssFeed].
  static RssFeed _parseRssFeed(XmlDocument document) {
    final channel = document.findAllElements('channel').firstOrNull;
    if (channel == null) {
      throw Exception('No channel element found in RSS feed');
    }
    final items = channel.findAllElements('item').map(_parseRssItem).toList();

    return RssFeed(
      title: channel.findElements('title').firstOrNull?.text,
      description: channel.findElements('description').firstOrNull?.text,
      link: channel.findElements('link').firstOrNull?.text,
      items: items,
    );
  }

  /// Parses an XML <item> element into an [RssItem].
  static RssItem _parseRssItem(XmlElement element) {
    final mediaGroup = element.findElements('media:group').firstOrNull;
    final mediaContent = mediaGroup?.findAllElements('media:content') ??
        element.findAllElements('media:content');

    return RssItem(
      title: element.findElements('title').firstOrNull?.text,
      description: element.findElements('description').firstOrNull?.text,
      link: element.findElements('link').firstOrNull?.text,
      pubDate: element.findElements('pubDate').firstOrNull?.text,
      enclosure: _parseEnclosure(element),
      media: _parseMedia(mediaContent),
    );
  }

  /// Parses an <enclosure> element into an [RssEnclosure].
  static RssEnclosure? _parseEnclosure(XmlElement element) {
    final enclosure = element.findElements('enclosure').firstOrNull;
    if (enclosure == null) return null;
    return RssEnclosure(
      url: enclosure.getAttribute('url'),
      type: enclosure.getAttribute('type'),
    );
  }

  /// Parses <media:content> elements into an [RssMedia].
  static RssMedia? _parseMedia(Iterable<XmlElement> mediaElements) {
    if (mediaElements.isEmpty) return null;
    final contents = mediaElements
        .map((e) => RssMediaContent(
              url: e.getAttribute('url'),
              type: e.getAttribute('type'),
            ))
        .toList();
    return RssMedia(contents: contents);
  }

  /// Extracts an image URL from an [RssItem].
  ///
  /// Checks `media:content`, `enclosure`, and `<img>` tags in `description`.
  /// Returns [fallbackImageUrl] if provided and no valid image is found.
  static String? getImageUrl(RssItem item, {String? fallbackImageUrl}) {
    // Check media content
    if (item.media != null && item.media!.contents.isNotEmpty) {
      final url = item.media!.contents.first.url;
      if (url != null &&
          _isValidImageUrl(url, item.media!.contents.first.type)) {
        return url;
      }
    }
    // Check enclosure
    if (item.enclosure != null && item.enclosure!.url != null) {
      if (_isValidImageUrl(item.enclosure!.url, item.enclosure!.type)) {
        return item.enclosure!.url;
      }
    }
    // Parse <img> tag from description
    if (item.description != null) {
      final imgRegExp = RegExp(r'<img[^>]+src="([^"]+)"', caseSensitive: false);
      final match = imgRegExp.firstMatch(item.description!);
      if (match != null && match.groupCount >= 1) {
        final url = match.group(1);
        if (url != null && _isValidImageUrl(url, null)) {
          return url;
        }
      }
    }
    // Return fallback if provided
    return fallbackImageUrl;
  }

  /// Validates if a URL is likely an image based on its extension or MIME type.
  static bool _isValidImageUrl(String? url, String? mimeType) {
    if (url == null) return false;
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    final imageMimeTypes = [
      'image/jpeg',
      'image/png',
      'image/gif',
      'image/bmp',
      'image/webp'
    ];
    return imageExtensions.any((ext) => url.toLowerCase().endsWith(ext)) ||
        (mimeType != null && imageMimeTypes.contains(mimeType.toLowerCase()));
  }

  /// Fetches an Open Graph image from the article's URL as a fallback (optional).
  ///
  /// This method is asynchronous and should be used sparingly (e.g., in detail screens).
  static Future<String?> getOpenGraphImage(String articleUrl) async {
    try {
      final response = await http.get(Uri.parse(articleUrl));
      if (response.statusCode != 200) return null;
      final ogImageRegExp = RegExp(
        r'<meta[^>]+property="og:image"[^>]+content="([^"]+)"',
        caseSensitive: false,
      );
      final match = ogImageRegExp.firstMatch(response.body);
      return match?.group(1);
    } catch (e) {
      return null;
    }
  }
}
