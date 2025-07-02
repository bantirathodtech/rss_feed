class UrlUtils {
  static String getFeedName(String url) {
    if (url.contains('bbc.com/news/world/rss.xml')) return 'BBC World News';
    if (url.contains('rss.nytimes.com')) return 'New York Times';
    if (url.contains('feeds.bbci.co.uk/news/technology/rss.xml'))
      return 'BBC Technology';
    if (url.contains('aajtak.in')) return 'Aaj Tak';
    if (url.contains('ndtv.com')) return 'NDTV';
    if (url.contains('tv9telugu.com')) return 'TV9 Telugu';
    if (url.contains('marathi.abplive.com')) return 'ABP Live Marathi';
    if (url.contains('marathi.tv9marathi.com')) return 'TV9 Marathi';
    return 'RSS Feed'; // Default name if no specific match
  }
}
