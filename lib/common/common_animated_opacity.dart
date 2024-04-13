import "package:flutter/material.dart";

class CommonAnimatedOpacityWidget extends StatelessWidget {
  const CommonAnimatedOpacityWidget({
    required this.opacity,
    required this.isForTop,
    super.key,
  });
  final double opacity;
  final bool isForTop;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(seconds: 3),
      child: Container(
        height: kTextTabBarHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isForTop
                ? <Color>[
                    theme.colorScheme.primary,
                    theme.scaffoldBackgroundColor.withOpacity(0.250),
                  ]
                : <Color>[
                    theme.scaffoldBackgroundColor.withOpacity(0.250),
                    theme.colorScheme.primary,
                  ],
          ),
        ),
      ),
    );
  }
}
