import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// A utility class for handling URL-related operations, such as launching URLs
/// and deriving feed names from URLs.
class UrlUtils {
  /// Returns a human-readable name for an RSS feed based on its [url].
  ///
  /// Matches the URL against known patterns to provide a friendly name.
  /// Returns 'RSS Feed' if no match is found.
  static String getFeedName(String url) {
    if (url.contains('bbc.com/news/world/rss.xml')) {
      return 'BBC World News';
    }
    if (url.contains('rss.nytimes.com')) {
      return 'New York Times';
    }
    if (url.contains('feeds.bbci.co.uk/news/technology/rss.xml')) {
      return 'BBC Technology';
    }
    if (url.contains('aajtak.in')) {
      return 'Aaj Tak';
    }
    if (url.contains('ndtv.com')) {
      return 'NDTV';
    }
    if (url.contains('tv9telugu.com')) {
      return 'TV9 Telugu';
    }
    if (url.contains('marathi.abplive.com')) {
      return 'ABP Live Marathi';
    }
    if (url.contains('marathi.tv9marathi.com')) {
      return 'TV9 Marathi';
    }
    if (url.contains('thehindu.com')) {
      return 'The Hindu';
    }
    return 'RSS Feed';
  }

  /// Launches a [url] in the device's default external browser.
  ///
  /// Returns `true` if the URL was launched successfully, `false` otherwise.
  static Future<bool> launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
      return false;
    }
  }
}
