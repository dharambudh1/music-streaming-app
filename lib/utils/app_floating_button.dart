import "dart:async";

import "package:flutter/material.dart";
import "package:music_streaming_app/utils/app_constants.dart";

class AppFloatingButton extends StatefulWidget {
  const AppFloatingButton({
    required this.iconData,
    required this.onPressed,
    super.key,
  });
  final IconData iconData;
  final Function() onPressed;

  @override
  State<AppFloatingButton> createState() => _AppFloatingButtonState();
}

class _AppFloatingButtonState extends State<AppFloatingButton> {
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
        return FloatingActionButton(
          elevation: elevation,
          shape: const CircleBorder(),
          onPressed: snapshot.hasData && snapshot.data == false
              ? () async {
                  unfocusFunction();
                  _controller.add(true);
                  await widget.onPressed();
                  _controller.add(false);
                }
              : null,
          child: snapshot.hasData && snapshot.data == false
              ? Icon(widget.iconData)
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
