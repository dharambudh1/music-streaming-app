import "package:flutter/material.dart";
import "package:music_streaming_app/common/common_cached_network_image.dart";
import "package:music_streaming_app/models/music_model.dart";

class CommonImageWidget extends StatelessWidget {
  const CommonImageWidget({
    required this.id,
    required this.model,
    required this.height,
    required this.width,
    super.key,
  });
  final String id;
  final MusicModel model;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "image_$id",
      transitionOnUserGestures: true,
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(8),
        child: CommonCachedNetworkImage(
          imageUrl: model.image ?? "",
          height: height,
          width: width,
        ),
      ),
    );
  }
}
