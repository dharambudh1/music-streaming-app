import "package:flutter/material.dart";
import "package:like_button/like_button.dart";

class CommonLikeWidget extends StatelessWidget {
  const CommonLikeWidget({
    required this.id,
    required this.isLiked,
    required this.addLike,
    required this.removeLike,
    super.key,
  });
  final String id;
  final bool isLiked;
  final Function() addLike;
  final Function() removeLike;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "like_$id",
      transitionOnUserGestures: true,
      child: LikeButton(
        isLiked: isLiked,
        size: 32,
        circleSize: 32,
        bubblesSize: 32,
        onTap: (bool value) {
          value ? removeLike() : addLike();
          return Future<bool>.value(!isLiked);
        },
      ),
    );
  }
}
