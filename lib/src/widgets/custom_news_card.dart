import 'package:flutter/material.dart';

import '../utils/string_utils.dart'; // Relative import for utilities

class CustomNewsCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String? imageUrl;
  final VoidCallback onTap;

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
