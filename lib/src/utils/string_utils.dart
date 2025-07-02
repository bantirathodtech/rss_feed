import 'package:intl/intl.dart';

class StringUtils {
  static String formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('MMM d, y • h:mm a').format(dateTime);
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  static String removeHtmlTags(String text) {
    // This regex matches any HTML tag (e.g., <div>, <p>, <img>)
    return text
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'),
            ' ') // Replace multiple whitespaces with single space
        .trim(); // Trim leading/trailing whitespace
  }

  static String cleanContent(String content) {
    // This is an alias for clarity; it performs the same HTML tag removal.
    return removeHtmlTags(content);
  }
}
