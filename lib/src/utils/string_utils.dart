import 'package:intl/intl.dart';

/// A utility class for common string manipulation tasks, such as date formatting
/// and cleaning HTML content.
class StringUtils {
  /// Formats a date string into a readable format: "MMM d, y • h:mm a".
  ///
  /// Example: "Jul 19, 2025 • 6:46 PM".
  /// Returns the original [dateString] if parsing fails.
  static String formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('MMM d, y • h:mm a').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  /// Removes HTML tags from the given [text] and normalizes whitespace.
  ///
  /// Replaces multiple whitespaces with a single space and trims the result.
  static String removeHtmlTags(String text) {
    return text
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Cleans HTML content by removing tags and normalizing whitespace.
  ///
  /// Alias for [removeHtmlTags] for clarity in context of RSS content.
  static String cleanContent(String content) {
    return removeHtmlTags(content);
  }
}
