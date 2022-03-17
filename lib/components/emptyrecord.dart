import 'package:flutter/material.dart';

class EmptyRecord extends StatelessWidget {
  const EmptyRecord({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text(
        "No Record Available",
        style: TextStyle(color: Colors.grey),
      ),
    ));
  }
}
