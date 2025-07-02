All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - 2025-07-02
### Changed
* Updated `flutter_lints` to `^6.0.0` and resolved associated static analysis warnings.
* Removed unnecessary null checks in `FeedDetailScreen` for `feed.items`.
* Removed the `library` declaration from `rss_feed.dart` as it's no longer necessary.

## [0.1.0] - 2025-07-02

### Added

* Initial release of the `rss_feed` package.
* `FeedListScreen` now accepts a `List<String> feedUrls` as a parameter, making feed sources configurable by the developer.
* `FeedDetailScreen` for showing articles from a selected feed.
* `CustomNewsCard` widget for displaying individual news items.
* `ArticleDetailScreen` for detailed article view.
* `WebViewScreen` for in-app article Browse.
* Utility functions (`FeedParser`, `StringUtils`, `UrlUtils`) for feed fetching, parsing, string manipulation, and URL-based feed naming.