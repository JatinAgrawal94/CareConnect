import 'package:flutter/material.dart';

class KeyboardDismiss extends StatelessWidget {
  final Widget childwidget;
  const KeyboardDismiss({Key key, @required this.childwidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: childwidget,
    );
  }
}
