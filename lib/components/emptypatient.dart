import 'package:flutter/material.dart';

class EmptyPatientList extends StatelessWidget {
  const EmptyPatientList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Text("No Patients Added",
                style: TextStyle(color: Colors.grey))));
  }
}
