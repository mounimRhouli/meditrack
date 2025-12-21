// lib/shared/widgets/image_viewer.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';

class ImageViewer extends StatelessWidget {
  final String imageUrl;
  final String? placeholderAssetPath;

  const ImageViewer({
    super.key,
    required this.imageUrl,
    this.placeholderAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}