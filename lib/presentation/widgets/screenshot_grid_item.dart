import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../data/models/mock_screenshot.dart';

class ScreenshotGridItem extends StatelessWidget {
  final AssetEntity? asset;
  final MockScreenshot? mockScreenshot;
  final VoidCallback? onTap;

  const ScreenshotGridItem({
    super.key,
    this.asset,
    this.mockScreenshot,
    this.onTap,
  }) : assert(asset != null || mockScreenshot != null);

  @override
  Widget build(BuildContext context) {
    final child = mockScreenshot != null ? _buildMockItem() : _buildAssetItem();

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'screenshot_${mockScreenshot?.id ?? asset?.id}',
        child: child,
      ),
    );
  }

  Widget _buildMockItem() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: mockScreenshot!.imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error_outline),
        ),
      ),
    );
  }

  Widget _buildAssetItem() {
    return FutureBuilder<Uint8List?>(
      future: asset!.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }
}
