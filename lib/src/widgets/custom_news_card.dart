import 'package:flutter/material.dart';

import '../utils/string_utils.dart'; // Relative import for utilities

/// A customizable card widget designed to display news article summaries.
///
/// It presents an article with a title, a truncated description,
/// publication date, and an optional image. Tapping the card triggers the [onTap] callback,
/// typically used for navigation to the full article.
class CustomNewsCard extends StatelessWidget {
  /// The title of the news article. This will be displayed prominently.
  final String title;

  /// The full description or summary of the article.
  /// This text will be cleaned of HTML tags and potentially truncated for display
  /// within the card to fit the layout.
  final String description;

  /// The publication date of the article.
  /// This date string will be formatted for better readability using [StringUtils.formatDate].
  final String date;

  /// An optional URL for the article's main image.
  /// If provided and valid, the image will be displayed at the top of the card.
  /// If null or fails to load, a placeholder will be shown.
  final String? imageUrl;

  /// The callback function that is executed when the card is tapped.
  ///
  /// This is typically used to navigate to a detailed view of the article
  /// or to open the article in a web view.
  final VoidCallback onTap;

  /// Creates a [CustomNewsCard].
  ///
  /// Requires a [title], [description], [date], and an [onTap] callback.
  /// [imageUrl] is optional.
  const CustomNewsCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0, // Added a little elevation for better visual
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)), // Rounded corners
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(8.0), // Match InkWell's ripple to card shape
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                // Clip the image to match card's rounded corners
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Image.network(
                  imageUrl!,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey)),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    StringUtils.formatDate(date), // Using utility function
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    StringUtils.removeHtmlTags(
                        description), // Using utility function
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
