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
      title: channel.findElements('title').firstOrNull?.innerText,
      description: channel.findElements('description').firstOrNull?.innerText,
      link: channel.findElements('link').firstOrNull?.innerText,
      items: items,
    );
  }

  /// Parses an XML `<item>` element into an [RssItem].
  static RssItem _parseRssItem(XmlElement element) {
    final mediaGroup = element.findElements('media:group').firstOrNull;
    final mediaContent = mediaGroup?.findAllElements('media:content') ??
        element.findAllElements('media:content');

    return RssItem(
      title: element.findElements('title').firstOrNull?.innerText,
      description: element.findElements('description').firstOrNull?.innerText,
      link: element.findElements('link').firstOrNull?.innerText,
      pubDate: element.findElements('pubDate').firstOrNull?.innerText,
      enclosure: _parseEnclosure(element),
      media: _parseMedia(mediaContent),
    );
  }

  /// Parses an `<enclosure>` element into an [RssEnclosure].
  static RssEnclosure? _parseEnclosure(XmlElement element) {
    final enclosure = element.findElements('enclosure').firstOrNull;
    if (enclosure == null) return null;
    return RssEnclosure(
      url: enclosure.getAttribute('url'),
      type: enclosure.getAttribute('type'),
    );
  }

  /// Parses `<media:content>` elements into an [RssMedia].
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
  /// Checks `<media:content>`, `<enclosure>`, and `<img>` tags in `description`.
  /// Returns [fallbackImageUrl] if provided and no valid image is found.
  static String? getImageUrl(RssItem item, {String? fallbackImageUrl}) {
    // Check media content
    if (item.media != null && item.media!.contents.isNotEmpty) {
      final url = item.media!.contents.first.url;
      if (url != null) {
        final fixedUrl = _fixImageUrl(url, item.link);
        if (fixedUrl != null &&
            _isValidImageUrl(fixedUrl, item.media!.contents.first.type)) {
          return fixedUrl;
        }
      }
    }
    // Check enclosure
    if (item.enclosure != null && item.enclosure!.url != null) {
      final fixedUrl = _fixImageUrl(item.enclosure!.url!, item.link);
      if (fixedUrl != null &&
          _isValidImageUrl(fixedUrl, item.enclosure!.type)) {
        return fixedUrl;
      }
    }
    // Parse <img> tag from description
    if (item.description != null) {
      final imgRegExp = RegExp(r'<img[^>]+src="([^"]+)"', caseSensitive: false);
      final match = imgRegExp.firstMatch(item.description!);
      if (match != null && match.groupCount >= 1) {
        final url = match.group(1);
        if (url != null) {
          final fixedUrl = _fixImageUrl(url, item.link);
          if (fixedUrl != null && _isValidImageUrl(fixedUrl, null)) {
            return fixedUrl;
          }
        }
      }
    }
    // Return fallback if provided
    return fallbackImageUrl;
  }

  /// Fixes a URL by adding scheme and host if needed, using the article's link as context.
  static String? _fixImageUrl(String url, String? articleLink) {
    // Remove leading/trailing whitespace
    url = url.trim();
    if (url.isEmpty) return null;

    // Add scheme if missing
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      if (url.startsWith('//')) {
        // Protocol-relative URL
        return 'https:$url';
      } else if (url.startsWith('/')) {
        // Relative path, use article link's host
        final baseUri = Uri.tryParse(articleLink ?? '');
        if (baseUri != null && baseUri.hasAuthority) {
          return '${baseUri.scheme}://${baseUri.host}$url';
        }
      } else {
        // Assume domain-only or malformed, try prepending https://
        final fixedUrl = 'https://$url';
        if (Uri.tryParse(fixedUrl)?.hasAuthority == true) {
          return fixedUrl;
        }
      }
    }

    // Validate final URL
    if (Uri.tryParse(url)?.hasAuthority == true) {
      return url;
    }
    return null;
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
