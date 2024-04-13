import "dart:async";

import "package:flutter/material.dart";
import "package:music_streaming_app/utils/app_constants.dart";

class AppElevatedButton extends StatefulWidget {
  const AppElevatedButton({
    required this.text,
    required this.onPressed,
    super.key,
  });
  final String text;
  final Function() onPressed;

  @override
  State<AppElevatedButton> createState() => _AppElevatedButtonState();
}

class _AppElevatedButtonState extends State<AppElevatedButton> {
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
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      child: StreamBuilder<bool>(
        initialData: false,
        stream: _controller.stream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
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
            child: snapshot.hasData && snapshot.data == false
                ? Text(widget.text)
                : const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
          );
        },
      ),
    );
  }
}

void unfocusFunction() {
  if (primaryFocus?.hasFocus ?? false) {
    primaryFocus?.unfocus();
  } else {}
  return;
}
