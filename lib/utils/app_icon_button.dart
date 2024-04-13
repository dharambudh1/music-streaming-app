import "dart:async";

import "package:flutter/material.dart";
import "package:music_streaming_app/utils/app_constants.dart";

class AppIconButton extends StatefulWidget {
  const AppIconButton({
    required this.iconData,
    required this.onPressed,
    super.key,
  });
  final IconData iconData;
  final Function() onPressed;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  final StreamController<bool> _controller = StreamController<bool>();
  final FocusNode? primaryFocus = FocusManager.instance.primaryFocus;

  @override
  void initState() {
    super.initState();
    _controller.add(false);
  }

  @override
  void dispose() {
    unawaited(_controller.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _controller.stream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return IconButton(
          style: IconButton.styleFrom(
            elevation: elevation,
            padding: EdgeInsets.zero,
          ),
          onPressed: snapshot.hasData && snapshot.data == false
              ? () async {
                  unfocusFunction();
                  _controller.add(true);
                  await widget.onPressed();
                  _controller.add(false);
                }
              : null,
          icon: snapshot.hasData && snapshot.data == false
              ? Icon(
                  widget.iconData,
                  size: 24,
                )
              : const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
        );
      },
    );
  }
}

void unfocusFunction() {
  if (primaryFocus?.hasFocus ?? false) {
    primaryFocus?.unfocus();
  } else {}
  return;
}
