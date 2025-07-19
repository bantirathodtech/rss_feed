import 'package:flutter_test/flutter_test.dart';
import 'package:rss_feed/src/models/rss_feed.dart';
import 'package:rss_feed/src/utils/feed_parser.dart';

void main() {
  test('getImageUrl extracts image from description', () {
    final item =
        RssItem(description: '<img src="https://example.com/image.jpg">');
    expect(FeedParser.getImageUrl(item), 'https://example.com/image.jpg');
  });
}
