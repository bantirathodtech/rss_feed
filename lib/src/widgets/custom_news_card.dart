import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/string_utils.dart';

/// A customizable card widget for displaying RSS article summaries.
///
/// Displays a title, description, date, and optional image. Tapping the card
/// triggers the [onTap] callback for navigation to the article's details.
class CustomNewsCard extends StatelessWidget {
  /// The title of the article.
  final String title;

  /// The description or summary of the article.
  final String description;

  /// The publication date of the article.
  final String date;

  /// Optional URL for the article's image.
  final String? imageUrl;

  /// Callback triggered when the card is tapped.
  final VoidCallback onTap;

  /// Optional custom placeholder widget for failed image loads.
  final Widget? placeholderImage;

  const CustomNewsCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    this.imageUrl,
    required this.onTap,
    this.placeholderImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8.0)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) =>
                      placeholderImage ??
                      Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: const Center(
                            child:
                                Icon(Icons.broken_image, color: Colors.grey)),
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
                    StringUtils.formatDate(date),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    StringUtils.removeHtmlTags(description),
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
