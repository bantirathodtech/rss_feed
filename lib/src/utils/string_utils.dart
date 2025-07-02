import 'package:intl/intl.dart'; // Required for date formatting

/// A utility class containing helper methods for common string manipulation tasks.
///
/// This includes methods for date formatting and cleaning HTML content from text.
class StringUtils {
  /// Formats a given date string into a readable format: "MMM d, y • h:mm a".
  ///
  /// Example: "Jul 2, 2025 • 8:23 PM"
  /// If the [dateString] cannot be parsed, the original string is returned.
  static String formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('MMM d, y • h:mm a').format(dateTime);
    } catch (e) {
      // Return original string if parsing fails (e.g., invalid date format)
      return dateString;
    }
  }

  /// Removes all HTML tags from the given [text].
  ///
  /// It also replaces multiple whitespaces with a single space and trims
  /// leading/trailing whitespace. This is useful for converting HTML content
  /// to plain text for display.
  static String removeHtmlTags(String text) {
    // This regex matches any HTML tag (e.g., <div>, <p>, <img>)
    return text
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'),
            ' ') // Replace multiple whitespaces with single space
        .trim(); // Trim leading/trailing whitespace
  }

  /// Cleans HTML content by removing all HTML tags.
  ///
  /// This is an alias for [removeHtmlTags] for clarity when dealing with content that might contain HTML.
  static String cleanContent(String content) {
    return removeHtmlTags(content);
  }
}
