import "package:flutter/material.dart";
import "package:music_streaming_app/models/music_model.dart";

class CommonInfoWidget extends StatelessWidget {
  const CommonInfoWidget({
    required this.id,
    required this.model,
    super.key,
  });
  final String id;
  final MusicModel model;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Hero(
          tag: "name_$id",
          transitionOnUserGestures: true,
          child: Text(
            model.name ?? "",
            style: theme.textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 2),
        const SizedBox(height: 2),
        Hero(
          tag: "by_$id",
          transitionOnUserGestures: true,
          child: Text(
            model.by ?? "",
            style: theme.textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
