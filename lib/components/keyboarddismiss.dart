import 'package:flutter/material.dart';

class KeyboardDismiss extends StatelessWidget {
  const KeyboardDismiss({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus.unfocus();
      }
    });
  }
}
