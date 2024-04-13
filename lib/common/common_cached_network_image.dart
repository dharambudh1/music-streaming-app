import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

class CommonCachedNetworkImage extends StatelessWidget {
  const CommonCachedNetworkImage({
    required this.imageUrl,
    required this.height,
    required this.width,
    super.key,
  });
  final String imageUrl;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
      useOldImageOnUrlChange: true,
      errorWidget: (BuildContext context, String url, Object error) {
        return const Icon(Icons.error);
      },
      progressIndicatorBuilder: (
        BuildContext context,
        String string,
        DownloadProgress progress,
      ) {
        return Center(
          child: CircularProgressIndicator(
            value: progress.progress,
          ),
        );
      },
    );
  }
}
