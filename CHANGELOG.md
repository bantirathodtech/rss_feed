# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2025-07-20
### Added
- Implemented `screenshots` field in `pubspec.yaml` for dedicated package gallery display on pub.dev.
- Added inline screenshots to `README.md` using Markdown tables for better visual documentation.



## [1.1.0] - 2025-07-20

- Added screenshots to README.md for improved documentation.
- Enhanced UI in FeedListScreen, FeedDetailScreen, and ArticleDetailScreen.
- Fixed `dart analyze` issues:
    - Escaped HTML in doc comments in feed_parser.dart.
    - Replaced deprecated `.text` with `.innerText` in feed_parser.dart.
    - Removed unused `theme` variables in feed_detail_screen.dart.
    - Replaced deprecated `withOpacity` with `withValues` in article_detail_screen.dart, feed_detail_screen.dart, feed_list_screen.dart.
    - Replaced deprecated `onBackground` with `onSurface` in feed_detail_screen.dart.
    - Fixed relative import in widget_test.dart to use package import.
- Removed misplaced assets from lib/src/assets/.
- Fixed asset paths in example/pubspec.yaml.


## [1.0.0] - 2025-07-19

### Added
- Custom RSS parsing using `xml: ^6.5.0`, replacing `rss_dart`.
- `RSSConfig` class for customizing themes, default images, and feed names.
- Image handling with `cached_network_image: ^3.4.2` for efficient loading.
- Optional Open Graph image fetching for articles without images.
- Custom `RssFeed`, `RssItem`, `RssEnclosure`, and `RssMedia` models.
- Enhanced documentation with detailed comments and updated README.
- Cross-platform support for Android, iOS, web, Windows, Linux, and macOS.

### Changed
- Updated `FeedParser` to use `xml` package for RSS parsing.
- Improved `RegExp` patterns for image extraction to avoid syntax errors.
- Enhanced `FeedDetailScreen` and `ArticleDetailScreen` to support new models and image handling.
- Updated example app to demonstrate `RSSConfig` usage.
- Aligned SDK constraints to `sdk: '>=3.5.0 <4.0.0'` and `flutter: '>=3.27.0'`.

### Removed
- Dependency on `rss_dart: ^1.0.13`.

## [0.1.2] - 2025-07-02

### Changed
- Updated `flutter_lints` to `^6.0.0` and resolved associated static analysis warnings.
- Removed unnecessary null checks in `FeedDetailScreen` for `feed.items`.
- Removed the `library` declaration from `rss_feed.dart` as it's no longer necessary.

## [0.1.0] - 2025-07-02

### Added
- Initial release of the `rss_feed` package.
- `FeedListScreen` accepting a `List<String> feedUrls` for configurable feed sources.
- `FeedDetailScreen` for showing articles from a selected feed.
- `CustomNewsCard` widget for displaying individual news items.
- `ArticleDetailScreen` for detailed article view.
- `WebViewScreen` for in-app article browsing.
- Utility functions (`FeedParser`, `StringUtils`, `UrlUtils`) for feed fetching, parsing, string manipulation, and URL-based feed naming.
