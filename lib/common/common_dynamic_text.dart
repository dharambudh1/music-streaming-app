import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:music_streaming_app/utils/custom_lottie_widget.dart";

class CommonDynamicText extends StatelessWidget {
  const CommonDynamicText({
    required this.opacity,
    required this.path,
    required this.title,
    required this.body,
    super.key,
  });
  final double opacity;
  final String path;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(seconds: 1),
      child: Row(
        children: <Widget>[
          CustomLottieWidget(
            path: path,
            height: 32,
            width: 32,
            onLoaded: (LottieComposition lottieComposition) {},
          ),
          const SizedBox(width: 8.0),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
