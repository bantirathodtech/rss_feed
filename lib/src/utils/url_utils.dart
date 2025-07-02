// lib/src/utils/url_utils.dart

import 'package:flutter/foundation.dart'; // For debugPrint, if used
import 'package:url_launcher/url_launcher.dart'; // This is crucial for launchExternalUrl

/// A utility class for handling URL-related operations,
/// such as launching external web pages and deriving feed names.
class UrlUtils {
  /// Determines a human-readable name for an RSS feed based on its [url].
  ///
  /// It checks the [url] against a predefined list of patterns and returns
  /// a corresponding common name. If no match is found, it defaults to "RSS Feed".
  static String getFeedName(String url) {
    // Corrected: Each 'if' statement now has a block {}
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
    return 'RSS Feed'; // Default name if no specific match
  }

  /// Launches a URL in the default external web browser of the device.
  ///
  /// Returns `true` if the URL was successfully launched, `false` otherwise.
  /// This method handles parsing the URL string into a [Uri] and checking
  /// if the URL can be launched before attempting to do so.
  ///
  /// Example:
  /// ```dart
  /// bool launched = await UrlUtils.launchExternalUrl('[https://pub.dev](https://pub.dev)');
  /// if (launched) {
  ///   debugPrint('URL launched successfully!');
  /// } else {
  ///   debugPrint('Failed to launch URL.');
  /// }
  /// ```
  static Future<bool> launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    } else {
      // Log an error if the URL cannot be launched for debugging
      debugPrint('Could not launch $url');
      return false;
    }
  }
}
