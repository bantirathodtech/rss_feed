import 'package:flutter/material.dart';

/// Configuration class for customizing the RSS Feed package's behavior and appearance.
///
/// Allows developers to set custom themes, default images, and feed names.
class RSSConfig {
  /// Custom theme for the RSS feed UI. If null, uses the app's default theme.
  final ThemeData? theme;

  /// Default image URL to use when no image is found in an RSS item.
  final String? defaultImageUrl;

  /// Map of feed URLs to custom display names.
  final Map<String, String>? feedNames;

  /// Whether to enable caching of feeds (not implemented in this version).
  final bool cacheEnabled;

  const RSSConfig({
    this.theme,
    this.defaultImageUrl,
    this.feedNames,
    this.cacheEnabled = false,
  });
}
