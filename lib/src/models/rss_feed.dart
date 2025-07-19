/// Models for representing RSS feed data, including feeds, items, and media content.
///
/// These models are used to parse and store RSS feed data fetched from a URL.
class RssFeed {
  /// The title of the feed (e.g., "BBC World News").
  final String? title;

  /// A brief description of the feed.
  final String? description;

  /// The URL to the feed's main website.
  final String? link;

  /// List of articles (items) in the feed.
  final List<RssItem> items;

  const RssFeed({
    this.title,
    this.description,
    this.link,
    required this.items,
  });
}

/// Represents an individual article within an RSS feed.
class RssItem {
  /// The title of the article.
  final String? title;

  /// The description or content of the article, often containing HTML.
  final String? description;

  /// The URL to the full article.
  final String? link;

  /// The publication date of the article (e.g., "Wed, 15 Nov 2023 14:30:00 GMT").
  final String? pubDate;

  /// The enclosure (e.g., image or media file) associated with the article.
  final RssEnclosure? enclosure;

  /// Media content (e.g., images or thumbnails) associated with the article.
  final RssMedia? media;

  const RssItem({
    this.title,
    this.description,
    this.link,
    this.pubDate,
    this.enclosure,
    this.media,
  });
}

/// Represents an enclosure element in an RSS item (e.g., an image or media file).
class RssEnclosure {
  /// The URL of the enclosure.
  final String? url;

  /// The MIME type of the enclosure (e.g., 'image/jpeg').
  final String? type;

  const RssEnclosure({this.url, this.type});
}

/// Represents media content in an RSS item (e.g., images or thumbnails).
class RssMedia {
  /// List of media content items (e.g., multiple images).
  final List<RssMediaContent> contents;

  const RssMedia({required this.contents});
}

/// Represents a single media content item (e.g., an image).
class RssMediaContent {
  /// The URL of the media content.
  final String? url;

  /// The MIME type of the media content (e.g., 'image/jpeg').
  final String? type;

  const RssMediaContent({this.url, this.type});
}
